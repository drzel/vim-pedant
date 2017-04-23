" Vim global plugin for changing iterm2 color palette when changing vim colorscheme
" Last Change:	2017-03-29
" Maintainer:	Sheldon Johnson
" License:	MIT

function! PedantColorScheme(colorscheme)
  if !exists("g:pedant_options")
    echo "g:pedant_options variable not defined"
  else
    let &background = g:pedant_options[a:colorscheme][1]
    let g:itermcolors_file = g:pedant_options[a:colorscheme][0]
    call UpdateIterm()
    execute "colorscheme " . a:colorscheme
  endif
endfunction

function! UpdateIterm()
ruby << EOF
require 'plist'

class ITermColorFile
  LOOKUP = { "0" => "Ansi 0 Color",
             "1" => "Ansi 1 Color",
             "2" => "Ansi 2 Color",
             "3" => "Ansi 3 Color",
             "4" => "Ansi 4 Color",
             "5" => "Ansi 5 Color",
             "6" => "Ansi 6 Color",
             "7" => "Ansi 7 Color",
             "8" => "Ansi 8 Color",
             "9" => "Ansi 9 Color",
             "a" => "Ansi 10 Color",
             "b" => "Ansi 11 Color",
             "c" => "Ansi 12 Color",
             "d" => "Ansi 13 Color",
             "e" => "Ansi 14 Color",
             "f" => "Ansi 15 Color",
             "g" => "Foreground Color",
             "h" => "Background Color",
             "l" => "Cursor Color" } 

  def initialize(file)
    @xml_obj =  Plist::parse_xml(file)
  end

  def update_iterm
    VIM::command("silent !echo -e \"#{vim_escape_codes}\"")
  end

  private

  def vim_escape_codes
    to_hash.map { |identifier, color| vim_escape_code(identifier, color) }.join
  end

  def vim_escape_code(identifier, color)
    "\\\\033]P#{identifier}#{color}\\\\033\\\\\\\\"
  end

  def to_hash
    @to_hash ||= LOOKUP.transform_values do |identifier|
      xml_color_obj = @xml_obj[identifier]
      normal_color = NormalColor.new(r: xml_color_obj['Red Component'],
                                     g: xml_color_obj['Green Component'],
                                     b: xml_color_obj['Blue Component'])
      normal_color.to_hex_color.to_s
    end
  end
end

class Color
  def initialize(r:, g:, b:)
    @red   = r
    @green = g
    @blue  = b
  end

  def to_hash
    { r: @red, g: @green, b: @blue }
  end
end

class RGBColor < Color
  def to_hex_color
    hsh = to_hash.transform_values { |value| "%02x" % value }
    HexColor.new hsh
  end
end

class NormalColor < Color
  def to_rgb_color
    hsh = to_hash.transform_values { |value| 255 * value }
    RGBColor.new hsh
  end

  def to_hex_color
    to_rgb_color.to_hex_color
  end
end

class HexColor < Color
  def to_s
    "#{@red}#{@green}#{@blue}"
  end
end

file = VIM::evaluate("g:itermcolors_file")
colors = ITermColorFile.new(file)
colors.update_iterm
EOF
endfunction

command! -nargs=1 Pcolorscheme call PedantColorScheme(<q-args>)
