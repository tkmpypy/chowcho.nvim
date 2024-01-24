local ui = require("chowcho.ui")

local chowcho = {}

local _float_wins = {}

-- for default options
local _opt = {
  icon_enabled = false,
  text_color = "#FFFFFF",
  bg_color = nil,
  active_border_color = "#B400C8",
  border_style = "single",
  use_exclude_default = true,
  exclude = nil,
  zindex = 10000,
}

local str = function(v)
  return v .. ""
end

local is_enable_icon = function(opt)
  if opt.icon_enabled then
    local loaded_devicons = vim.api.nvim_get_var("loaded_devicons")
    if loaded_devicons < 1 then
      return false
    end

    return require("nvim-web-devicons").has_loaded()
  end

  return false
end

local calc_center_win_pos = function(win)
  local w = vim.api.nvim_win_get_width(win)
  local h = vim.api.nvim_win_get_height(win)

  return { w = math.ceil(w / 2), h = math.ceil(h / 2) }
end

local set_highlight = function(opt)
  if opt.bg_color == nil or opt.bg_color == "" then
    vim.cmd("hi! ChowchoFloat guifg=" .. opt.text_color)
    vim.cmd("hi! ChowchoActiveFloat guifg=" .. opt.active_border_color)
  else
    vim.cmd("hi! ChowchoFloat guifg=" .. opt.text_color .. " guibg=" .. opt.bg_color)
    vim.cmd("hi! ChowchoActiveFloat guifg=" .. opt.active_border_color .. " guibg=" .. opt.bg_color)
  end
end

local win_close = function()
  for i, v in ipairs(_float_wins) do
    if v ~= nil then
      vim.api.nvim_win_close(v, true)
      _float_wins[i] = nil
    end
  end
end

chowcho.run = function(fn, opt)
  local opt_local = {}
  opt = opt or _opt
  for k, v in pairs(_opt) do
    opt_local[k] = opt[k] ~= nil and opt[k] or v
  end
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local current_win = vim.api.nvim_get_current_win()

  set_highlight(opt_local)

  local _wins = {}
  for i, v in ipairs(wins) do
    if not vim.api.nvim_win_is_valid(v) then
      goto continue
    end
    local pos = calc_center_win_pos(v)
    local buf = vim.api.nvim_win_get_buf(v)
    local bt = vim.api.nvim_get_option_value("buftype", { buf = buf })
    if bt ~= "prompt" then
      local fname = vim.fn.expand("#" .. buf .. ":t")

      if opt_local.use_exclude_default then
        if fname == "" then
          goto continue
        end
      end

      if opt_local.exclude ~= nil then
        if opt_local.exclude(buf, v) then
          goto continue
        end
      end

      local icon, hl_name = "", ""
      if is_enable_icon(opt_local) then
        icon, hl_name = ui.get_icon(fname)
        fname = icon .. " " .. fname
      end
      local bufnr, f_win, win =
        ui.create_floating_win(pos.w, pos.h, v, { str(i), fname }, opt_local.border_style, _opt.zindex)

      if is_enable_icon(opt_local) then
        local line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)
        local icon_col = line[1]:find(icon)
        local end_col = icon_col + vim.fn.strlen(icon)
        vim.api.nvim_buf_add_highlight(bufnr, -1, hl_name, 1, icon_col, end_col)
      end
      table.insert(_float_wins, f_win)
      table.insert(_wins, win)

      if v == current_win then
        vim.api.nvim_set_option_value("winhl", "FloatBorder:ChowchoActiveFloat", { win = f_win })
      end
    end
    ::continue::
  end

  local timer = vim.loop.new_timer()
  timer:start(
    10,
    0,
    vim.schedule_wrap(function()
      local success, val = pcall(vim.fn.getchar)
      if success then
        val = vim.fn.nr2char(val)
        if val ~= nil then
          for _, v in ipairs(_wins) do
            if v ~= nil then
              if v.no == str(val) then
                (fn or vim.api.nvim_set_current_win)(v.win)
                break
              end
            end
          end
        end
      end
      win_close()
      timer:stop()
    end)
  )
end

--[[
{
  icon_enabled = true,
  text_color = '#FFFFFF',
  bg_color = '#555555',
  active_border_color = '#B400C8',
  border_style = 'rounded' -- 'default', 'rounded',
  use_exclude_default = true,
  exclude = nil
}
--]]
chowcho.setup = function(opt)
  if type(opt) == "table" then
    _opt = vim.tbl_deep_extend("force", _opt, opt)
  else
    error("[chowcho.nvim] option is must be table")
  end

  -- link highlights float border
  -- vim.cmd([[
  --   hi! link FloatBorder ChowchoFloat
  --   hi! link FloatBorder ChowchoActiveFloat
  -- ]])
end

return chowcho
