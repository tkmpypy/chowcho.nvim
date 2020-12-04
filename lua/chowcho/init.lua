local chowcho = {}

local _float_wins = {}
local _wins = {}
local _exclude_ft = vim.g.chowcho_exclude_filetypes

local str = function(v) return v .. '' end

local centering_str = function(src, target) 
  local ws = math.ceil(#target / 2)
  for _=2, ws do
    src = ' ' .. src
  end

  return src
end

local create_floating_win = function(x, y, win, label)
  local buf = vim.api.nvim_create_buf(false, true)

  local w = 0
  local win_num = label[1]
  if (#label[1] >= #label[2]) then
    w = #label[2]
    label[2] = centering_str(label[2], label[1])
  else
    w = #label[2]
    label[1] = centering_str(label[1], label[2])
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, label)

  local opt = {
    win = win,
    relative = 'win',
    width = w,
    height = 2,
    col = x,
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
  for i, v in ipairs(wins) do
    local pos = calc_center_win_pos(v)
    local buf = vim.api.nvim_win_get_buf(v)
    local fname = vim.fn.expand('#'..buf..':t')
    create_floating_win(pos.w, pos.h, v, {
      str(i), 
      fname
    })
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

return chowcho
