local integ = require("chowcho.integrator")

---@type Chowcho.Selector
local M = {}
local _state = {
  windows = {},
  global = {},
}

M.new = function(opts)
  local integrator = integ.new()

  local obj = {
    opts = opts,
    integrator = integrator,
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

M.hide = function(_)
  restore()
  clear()
end

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

M.pre_proc = function(self)
  self.integrator:pre_proc()
end
M.post_proc = function(self)
  self.integrator:post_proc()
end

return M
