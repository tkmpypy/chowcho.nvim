---@class Chowcho.Selector.Statusline
---@field opts Chowcho.Config.Root
local M = {}
local _state = {
  windows = {},
  global = {},
}

---@param opts Chowcho.Config.Root
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
  vim.api.nvim_set_option_value("winhl", "StatusLine:ChowchoStatusLine,StatusLineNC:ChowchoStatusLineNC", { win = win })

  return { win = win, label = label }
end

---@type Chowcho.UI.HideFn
M.hide = function(_)
  restore()
  clear()
end

---@type Chowcho.UI.HighlightFn
M.highlight = function(self)
  local colors = self.opts.selector.statusline.color
  local hl_groups = {
    { name = "ChowchoStatusLine", default = "StatusLine", bg = colors.background.active, fg = colors.label.active },
    {
      name = "ChowchoStatusLineNC",
      default = "StatusLineNC",
      bg = colors.background.inactive,
      fg = colors.label.inactive,
    },
  }

  for _, hl in pairs(hl_groups) do
    local default = vim.api.nvim_get_hl(0, { name = hl.default })
    local fg = string.format("#%06x", default.fg)
    local bg = string.format("#%06x", default.bg)
    if hl.fg ~= nil then
      fg = hl.fg
    end
    if hl.bg ~= nil then
      bg = hl.bg
    end
    vim.api.nvim_set_hl(0, hl.name, {
      fg = fg,
      bg = bg,
    })
  end
end

return M
