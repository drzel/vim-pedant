# vim-pedant
Change iterm2 palette when changing colorschemes

## The problem
Changing colorscheme won't change the background color of the bordering window. For pedants like me, this isn't acceptable.

## The solution
This plugin allows you to map a corresponding `.itermcolors` file to vim's colorscheme, and vim will update the current iterm2 profile to match. Works well with [FZF](https://github.com/junegunn/fzf).

## Installation
Install with a vim plugin manager (or don't).

## Usage
Pedant looks for its configuration inside a vim dictionary `g:pedant_options`. Each colorscheme should have its name as the key, and an array as its value, with the first item being the full path the the corresponding `.itermcolors` file, and the second item is passed to `set background=`.

E.g. In your `.vimrc` add:
```vim
let g:pedant_options = {
      \ 'nova': ['/Users/<username>/itermcolors/nova.itermcolors', 'dark'],
      \ 'gruvbox': ['/Users/<username>/itermcolors/gruvbox.itermcolors', 'light'],
      \ 'deep-space': ['/Users/<username>/itermcolors/deep-space.itermcolors', 'dark'],
      \ }
```

## Notes
This is a nasty hack.

Initially I just changed the iterm2 profile when changing colorschemes. This worked will with one caveat, font size. I often use <kbd>⌘</kbd>+<kbd>=</kbd> and <kbd>⌘</kbd>+<kbd>-</kbd> to zoom, but whenever the profile is changed, iterm will revert to the profile's font size. Honestly, font size shouldn't be part of the profile, and there is an open issue regarding this: https://gitlab.com/gnachman/iterm2/issues/5645

So instead this plugin will update the colors of the current session. This works very well and doesn't change your font size. The downside of this is when a new split is launched it will default to whichever profile is currently selected. Pull requests warmly welcomed!

Works well with [colorscheme-switcher.vim](http://peterodding.com/code/vim/colorscheme-switcher/).
