# chowcho.nvim

- simply window operation for neovim written in lua
- inspired by [you-are-here.vim](https://github.com/bignimbus/you-are-here.vim)

## Installation

- `lazy.nvim`

```lua
{
  "tkmpypy/chowcho.nvim",
  config = function()
    require("chowcho").setup({...})
  end,
},
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
  -- Must be a single character. The length of the array is the maximum number of windows that can be moved.
  labels = { "a", "b", "c", "d", "e", "f", "g", "h", "i" },
  selector = "statusline", -- `float` or `statusline` (default: `float`)
  use_exclude_default = true,
  exclude = function(buf, win)
    -- exclude noice.nvim's cmdline_popup
    local bt = vim.api.nvim_get_option_value("buftype", { buf = buf })
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
    if bt == "nofile" and (ft == "noice" or ft == "vim") then
      return true
    end
    return false
  end,
  selector = {
    float = {
      border_style = "rounded",
      icon_enabled = true,
      color = {
        label = {
          active = "#c8cfff",
          inactive = "#ababab",
        },
        text = {
          active = "#fefefe",
          inactive = "#d0d0d0",
        },
        border = {
          active = "#b400c8",
          inactive = "#fefefe",
        },
      },
      zindex = 1,
    },
    statusline = {
      color = {
        label = {
          active = "#fefefe",
          inactive = "#d0d0d0",
        },
        background = {
          active = "#3d7172",
          inactive = "#203a3a",
        },
      },
    },
  },
}
```

## Screenshot

![image](https://user-images.githubusercontent.com/17525828/101620670-2c517100-3a58-11eb-91c8-575fdde092f1.png)
![image](https://user-images.githubusercontent.com/17525828/101620683-31162500-3a58-11eb-91a2-e7fc36e708a7.png)
