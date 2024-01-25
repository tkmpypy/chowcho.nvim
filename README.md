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
    border_style = "rounded",
    active_border_color = "#b400c8",
    active_text_color = "#ffffff",
    deactive_border_color = "#fefefe",
    deactive_text_color = "#d0d0d0",
    icon_enabled = true,
    use_default_exclude = true,
    exclude = function(buf, win)
      -- exclude noice.nvim's cmdline_popup
      local bt = vim.api.nvim_get_option_value("buftype", { buf = buf })
      local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
      if bt == "nofile" and (ft == "noice" or ft == "vim") then
        return true
      end
      return false
    end,
}
```

## Screenshot

![image](https://user-images.githubusercontent.com/17525828/101620670-2c517100-3a58-11eb-91c8-575fdde092f1.png)
![image](https://user-images.githubusercontent.com/17525828/101620683-31162500-3a58-11eb-91a2-e7fc36e708a7.png)
