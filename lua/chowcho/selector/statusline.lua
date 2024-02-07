local ui = require("chowcho.ui")
local util = require("chowcho.util")

local M = {}
local _state = {
  windows = {},
  global = {},
}

---@param opts Chowcho.Config
---@return Chowcho.UI.Selector
M.new = function(opts)
  local obj = {
    opts = opts,
  }
  _state.global = {
    laststatus = vim.o.laststatus,
    cmdheight = vim.o.cmdheight,
  }

  setmetatable(obj, { __index = M })

  return obj
end

local clear = function()
  _state = {
    windows = {},
    global = {},
  }
end

local restore = function()
  vim.o.laststatus = _state.global.laststatus
  vim.o.cmdheight = _state.global.cmdheight

  for _, w in ipairs(_state.windows) do
    if vim.api.nvim_win_is_valid(w.win) then
      vim.wo[w.win].statusline = w.statusline
    end
  end
end

---@type Chowcho.UI.ShowFn
M.show = function(self, idx, win)
  vim.o.laststatus = 2
  vim.o.cmdheight = 1

  if not vim.tbl_contains(_state.windows, function(v)
    return v.win == win
  end, { predicate = true }) then
    table.insert(_state.windows, { win = win, statusline = vim.wo[win].statusline })
  end

  local label = self.opts.labels[idx]
  vim.wo[win].statusline = "%=" .. label .. "%="

  return { win = win, label = label }
end

---@type Chowcho.UI.HideFn
M.hide = function(_)
  restore()
  clear()
end

return M
