# chowcho.nvim

- simply window selector for neovim written in lua
- inspired by [you-are-here.vim](https://github.com/bignimbus/you-are-here.vim)

## Installation

- packer.nvim

```lua
use {'tkmpypy/chowcho.nvim'}
```

## Usage

Select the number after executing the command `Chowcho` or after calling the lua function.

```lua
require('chowcho').run()
```

## Config

call `setup` function

```lua
require('chowcho').setup {
  text_color = '#FFFFFF',
  bg_color = '#555555',
  active_border_color = '#0A8BFF',
  border_style = 'default' -- 'default', 'rounded',
}
```

## Screenshot
