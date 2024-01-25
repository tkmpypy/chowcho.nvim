local util = require("chowcho.util")
local ui = {}

ui.create_floating_win = function(x, y, win, label, border_style, zindex)
  local buf = vim.api.nvim_create_buf(false, true)

  local win_num = label[1]
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, { label[2] })

  local _x = x - (math.ceil(#label[2] / 2)) + 2

  local _content_w = vim.api.nvim_strwidth(label[2])
  local opt = {
    win = win,
    relative = "win",
    width = _content_w,
    height = 1,
    col = _x,
    row = y,
    anchor = "NW",
    style = "minimal",
    focusable = false,
    zindex = zindex,
    border = border_style,
    title = label[1],
    title_pos = "center",
  }
  local float_win = vim.api.nvim_open_win(buf, false, opt)

  return buf, float_win, { no = win_num, win = win, float = float_win }
end

ui.get_icon = function(fname)
  local ext = util.split(fname, ".")
  ext = ext[#ext] or ""
  local icon, hl_name = require("nvim-web-devicons").get_icon(fname, ext, { default = true })
  return icon or "", hl_name or ""
end

return ui
