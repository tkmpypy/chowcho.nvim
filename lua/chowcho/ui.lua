local util = require("chowcho.util")
local ui = {}

---@type fun(x:integer,y:integer,win:integer,contents:Chowcho.UI.FloatWinContents,border_style:Chowcho.BorderStyleType,zindex:integer): integer,integer,Chowcho.UI.Window
ui.create_floating_win = function(x, y, win, contents, border_style, zindex)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, { contents.name })
  local _x = x - (math.ceil(#contents.name / 2)) + 2

  local _content_w = vim.api.nvim_strwidth(contents.name)
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
    title = contents.label,
    title_pos = "center",
  }
  local float_win = vim.api.nvim_open_win(buf, false, opt)

  return buf, float_win, { label = contents.label, win = win }
end

ui.get_icon = function(fname)
  local ext = util.str.split(fname, ".")
  ext = ext[#ext] or ""
  local icon, hl_name = require("nvim-web-devicons").get_icon(fname, ext, { default = true })
  return icon or "", hl_name or ""
end

return ui
