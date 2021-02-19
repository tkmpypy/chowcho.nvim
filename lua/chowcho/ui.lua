local util = require('chowcho.util')
local ui = {}

local create_content = function(label, border_style)
  local no = label[1]
  local fname = label[2]
  local content = '[' .. no .. ']' .. ' ' .. fname
  local width = vim.fn.strwidth(content) + 2
  local border = border_style

  -- top and bottom
  local top = ''
  local bottom = ''
  for i = 1, width do
    if (i == 1) then
      top = border.topleft .. top
      bottom = border.botleft .. bottom
      content = border.left .. content
    elseif (i == width) then
      top = top .. border.topright
      bottom = bottom .. border.botright
      content = content .. border.right
    else
      top = top .. border.top
      bottom = bottom .. border.bot
    end
  end

  return {top, content, bottom}
end

ui.create_floating_win = function(x, y, win, label, border_style)
  local buf = vim.api.nvim_create_buf(false, true)

  local win_num = label[1]
  local content_tbl = create_content(label, border_style)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, content_tbl)

  local _x = x - (math.ceil(#content_tbl[2] / 2)) + 2

  local _content_w = vim.api.nvim_strwidth(content_tbl[2])
  local opt = {
    win = win,
    relative = 'win',
    width = _content_w,
    height = 3,
    col = _x,
    row = y,
    anchor = 'NW',
    style = 'minimal',
    focusable = false
  }

  local float_win = vim.api.nvim_open_win(buf, false, opt)

  vim.api.nvim_win_set_option(float_win, 'winhl', 'Normal:ChowchoFloat')

  return buf, float_win, {no = win_num, win = win, float = float_win}
end

ui.get_icon = function(fname)
  local ext = util.split(fname, '.')
  ext = ext[#ext] or ''
  local icon, hl_name = require('nvim-web-devicons').get_icon(fname, ext,
                                                        {default = true})
  return icon or '', hl_name or ''
end

return ui
