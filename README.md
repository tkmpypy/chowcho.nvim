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
  icon_enabled = true, -- required 'nvim-web-devicons' (default: false)
  text_color = '#FFFFFF',
  bg_color = '#555555',
  active_border_color = '#0A8BFF',
  border_style = 'default' -- 'default', 'rounded',
}
```

## Screenshot

![image](https://user-images.githubusercontent.com/17525828/101620670-2c517100-3a58-11eb-91c8-575fdde092f1.png)
![image](https://user-images.githubusercontent.com/17525828/101620683-31162500-3a58-11eb-91a2-e7fc36e708a7.png)
