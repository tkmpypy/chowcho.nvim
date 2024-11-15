local ui = require("chowcho.ui")

---@class Chowcho.Selector
local M = {}
local _float_wins = {}

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

---@param opts Chowcho.Config.Root
local is_enable_icon = function(opts)
  if opts.selector_style == "float" and opts.selector.float.icon_enabled then
    local loaded_devicons = vim.api.nvim_get_var("loaded_devicons")
    if loaded_devicons < 1 then
      return false
    end

    return require("nvim-web-devicons").has_loaded()
  end

  return false
end

M.show = function(self, idx, win)
  local pos = calc_center_win_pos(win)
  local current_win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)
  local fname = vim.fs.basename(vim.api.nvim_buf_get_name(buf))

  if fname == nil or fname == "" then
    fname = "[No Name]"
  end

  local icon, hl_name = "", ""
  if is_enable_icon(self.opts) then
    icon, hl_name = ui.get_icon(fname)
    fname = icon .. " " .. fname
  end

  local bufnr, f_winnr, win_label = ui.create_floating_win(
    pos.w,
    pos.h,
    win,
    { label = self.opts.labels[idx], name = fname },
    self.opts.selector.float.border_style,
    self.opts.selector.float.zindex
  )
  vim.api.nvim_set_option_value(
    "winhl",
    "FloatTitle:ChowchoFloatTitle,FloatBorder:ChowchoFloatBorder,NormalFloat:ChowchoFloatText",
    { win = f_winnr }
  )

  if is_enable_icon(self.opts) then
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

M.hide = function(_)
  for i, v in ipairs(_float_wins) do
    if v ~= nil then
      vim.api.nvim_win_close(v, true)
      _float_wins[i] = nil
    end
  end
end

M.highlight = function(self)
  local colors = self.opts.selector.float.color
  local hl_groups = {
    { name = "ChowchoActiveFloatBorder", default = "Special", color = colors.border.active, fallback = "#b400c8" },
    { name = "ChowchoActiveFloatText", default = "Title", color = colors.text.active, fallback = "#fefefe" },
    { name = "ChowchoActiveFloatTitle", default = "Normal", color = colors.label.active, fallback = "c8cfff" },
    { name = "ChowchoFloatBorder", default = "FloatBorder", color = colors.border.inactive, fallback = "#fefefe" },
    { name = "ChowchoFloatText", default = "Normal", color = colors.text.inactive, fallback = "#d0d0d0" },
    { name = "ChowchoFloatTitle", default = "Title", color = colors.label.inactive, fallback = "#ababab" },
  }

  for _, hl in pairs(hl_groups) do
    local color = nil
    if hl.color ~= nil then
      color = hl.color
    else
      local default = vim.api.nvim_get_hl(0, { name = hl.default })
      if default.fg == nil then
        color = hl.fallback
      else
        color = string.format("#%06x", default.fg)
      end
    end

    vim.api.nvim_set_hl(0, hl.name, {
      fg = color,
    })
  end
end

M.pre_proc = function(_) end
M.post_proc = function(_) end

return M
