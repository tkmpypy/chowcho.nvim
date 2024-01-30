local ui = require("chowcho.ui")
local util = require("chowcho.util")

local M = {}
local _float_wins = {}

---@param opts Chowcho.Config
---@return Chowcho.UI.Selector
M.new = function(opts)
  local obj = {
    opts = opts,
  }
  setmetatable(obj, { __index = M })

  return obj
end

---@param win integer
local calc_center_win_pos = function(win)
  local w = vim.api.nvim_win_get_width(win)
  local h = vim.api.nvim_win_get_height(win)

  return { w = math.ceil(w / 2), h = math.ceil(h / 2) }
end

---@type Chowcho.UI.ShowFn
M.show = function(self, idx, win)
  local pos = calc_center_win_pos(win)
  local current_win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)
  local fname = vim.fs.basename(vim.api.nvim_buf_get_name(buf))

  if fname == nil or fname == "" then
    fname = "[No Name]"
  end

  local icon, hl_name = "", ""
  if util.opt.is_enable_icon(self.opts) then
    icon, hl_name = ui.get_icon(fname)
    fname = icon .. " " .. fname
  end

  local bufnr, f_winnr, win_label = ui.create_floating_win(
    pos.w,
    pos.h,
    win,
    { label = self.opts.labels[idx], name = fname },
    self.opts.border_style,
    self.opts.zindex
  )
  vim.api.nvim_set_option_value(
    "winhl",
    "FloatTitle:ChowchoFloatTitle,FloatBorder:ChowchoFloatBorder,NormalFloat:ChowchoFloatText",
    { win = f_winnr }
  )

  if util.opt.is_enable_icon(self.opts) then
    local line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)
    local icon_col = line[1]:find(icon) - 1
    local end_col = icon_col + vim.fn.strlen(icon)
    vim.api.nvim_buf_add_highlight(bufnr, -1, hl_name, 0, icon_col, end_col)
  end
  table.insert(_float_wins, f_winnr)

  if win == current_win then
    vim.api.nvim_set_option_value(
      "winhl",
      "FloatTitle:ChowchoActiveFloatTitle,FloatBorder:ChowchoActiveFloatBorder,NormalFloat:ChowchoActiveFloatText",
      { win = f_winnr }
    )
  end

  return win_label
end

---@type Chowcho.UI.HideFn
M.hide = function(_)
  for i, v in ipairs(_float_wins) do
    if v ~= nil then
      vim.api.nvim_win_close(v, true)
      _float_wins[i] = nil
    end
  end
end

return M
