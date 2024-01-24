# chowcho.nvim

- simply window operation for neovim written in lua
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

Optionally, run an arbitrary function which receives winid.
The example below hides a selected window.

```lua
require('chowcho').run(vim.api.nvim_win_hide)
```

## Config

call `setup` function

```lua
require('chowcho').setup {
  icon_enabled = true, -- required 'nvim-web-devicons' (default: false)
  text_color = '#FFFFFF',
  bg_color = '#555555',
  active_border_color = '#0A8BFF',
  border_style = 'rounded', -- default is 'single'. See details ':h nvim_open_win'
  use_exclude_default = false,
  exclude = function(buf, win)
    -- Exclude a window from the choice based on its buffer information.
    -- This option is applied iff `use_exclude_default = false`.
    -- Note that below is identical to the `use_exclude_default = true`.
    local fname = vim.fn.expand('#' .. buf .. ':t')
    return fname == ''
  end,
  zindex = 10000, -- sufficiently large value to show on top of the other windows
}
```

## Screenshot

![image](https://user-images.githubusercontent.com/17525828/101620670-2c517100-3a58-11eb-91c8-575fdde092f1.png)
![image](https://user-images.githubusercontent.com/17525828/101620683-31162500-3a58-11eb-91a2-e7fc36e708a7.png)
