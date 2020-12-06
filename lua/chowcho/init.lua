local chowcho = {}

local _float_wins = {}
local _wins = {}

-- for default options
local _opt = {
  text_color = '#FFFFFF',
  bg_color = '#555555',
  active_border_color = '#D2D',
  exclude_filetypes = {'LuaTree', 'packer'},
  border_style = 'default'
}

local _border_style = {
  default = {
    topleft = '╔',
    topright = '╗',
    top = '═',
    left = '║',
    right = '║',
    botleft = '╚',
    botright = '╝',
    bot = '═'
  },
  fancy = {} -- TODO(tkmpypy): unimplemented
}

local str = function(v) return v .. '' end

local create_content = function(label)
  local no = label[1]
  local fname = label[2]
  local content = '[' .. no .. ']' .. ' ' .. fname
  local width = #content + 2
  local border = _border_style[_opt.border_style]

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

local create_floating_win = function(x, y, win, label)
  local buf = vim.api.nvim_create_buf(false, true)

  local win_num = label[1]
  local content_tbl = create_content(label)
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

  local window = vim.api.nvim_open_win(buf, false, opt)

  vim.api.nvim_win_set_option(window, 'winhl', 'Normal:ChowchoFloat')
  table.insert(_float_wins, window)
  table.insert(_wins, {no = win_num, win = win})

end

local calc_center_win_pos = function(win)
  local w = vim.api.nvim_win_get_width(win)
  local h = vim.api.nvim_win_get_height(win)

  return {w = math.ceil(w / 2), h = math.ceil(h / 2)}
end

chowcho.run = function()
  _wins = {}
  local wins = vim.api.nvim_list_wins()

  vim.cmd('hi! ChowchoFloat guifg=' .. _opt.text_color .. ' guibg=' ..
              _opt.bg_color)
  for i, v in ipairs(wins) do
    local pos = calc_center_win_pos(v)
    local buf = vim.api.nvim_win_get_buf(v)
    local fname = vim.fn.expand('#' .. buf .. ':t')
    if (fname == '') then fname = 'NO NAME' end
    create_floating_win(pos.w, pos.h, v, {str(i), fname})
  end

  local timer = vim.loop.new_timer()
  timer:start(10, 0, vim.schedule_wrap(function()
    local val = vim.fn.getchar()
    val = vim.fn.nr2char(val)
    if (val ~= nil) then
      for _, v in ipairs(_wins) do
        if (v ~= nil) then
          if (v.no == str(val)) then
            vim.api.nvim_set_current_win(v.win)
            break
          end
        end
      end
    end
    chowcho.on_cursor_moved()
    timer:close()
  end))

end

chowcho.on_cursor_moved = function()
  for i, v in ipairs(_float_wins) do
    if (v ~= nil) then
      vim.api.nvim_win_close(v, true)
      _float_wins[i] = nil
    end
  end
end

--[[
{
  text_color = '#FFFFFF'
  bg_color = '#555555'
  active_border_color = '#D2D'
  exclude_filetypes = {'LuaTree', 'packer'},
  border_style = 'fancy' -- 'default', 'fancy'
}
--]]
chowcho.setup = function(opt)
  if (type(opt) == 'table') then
    if (opt.text_color) then _opt.text_color = opt.text_color end
    if (opt.bg_color) then _opt.bg_color = opt.bg_color end
    if (opt.active_border_color) then
      _opt.active_border_color = opt.active_border_color
    end
    if (opt.exclude_filetypes) then
      _opt.exclude_filetypes = opt.exclude_filetypes
    end
    if (opt.border_style) then _opt.border_style = opt.border_style end
  else
    error('[chowcho.nvim] option is must be table')
  end
end

return chowcho
