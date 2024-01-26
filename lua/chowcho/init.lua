local ui = require("chowcho.ui")

local chowcho = {}

local _float_wins = {}

--TODO:
--  - Add label color
---@type Chowcho.Config
local _default_opts = {
  icon_enabled = false,
  active_border_color = nil,
  deactive_border_color = nil,
  active_text_color = nil,
  deactive_text_color = nil,
  border_style = "single",
  use_exclude_default = true,
  exclude = nil,
  zindex = 10000,
  labels = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
}

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
  local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
  local float_hl = vim.api.nvim_get_hl(0, { name = "FloatBorder" })
  local sp_hl = vim.api.nvim_get_hl(0, { name = "Special" })

  if opt.active_border_color == nil then
    opt.active_border_color = string.format("#%06x", sp_hl.fg)
  end
  if opt.active_text_color == nil then
    opt.active_text_color = string.format("#%06x", normal_hl.fg)
  end
  if opt.deactive_border_color == nil then
    opt.deactive_border_color = string.format("#%06x", float_hl.fg)
  end
  if opt.deactive_text_color == nil then
    opt.deactive_text_color = string.format("#%06x", normal_hl.fg)
  end

  vim.api.nvim_set_hl(0, "ChowchoFloatBorder", {
    fg = opt.deactive_border_color,
  })
  vim.api.nvim_set_hl(0, "ChowchoFloatText", {
    fg = opt.deactive_text_color,
  })
  vim.api.nvim_set_hl(0, "ChowchoActiveFloatBorder", {
    fg = opt.active_border_color,
  })
  vim.api.nvim_set_hl(0, "ChowchoActiveFloatText", {
    fg = opt.active_text_color,
  })
end

local win_close = function()
  for i, v in ipairs(_float_wins) do
    if v ~= nil then
      vim.api.nvim_win_close(v, true)
      _float_wins[i] = nil
    end
  end
end

---@type Chowcho.RunFn
chowcho.run = function(fn, opt)
  local opt_local = vim.tbl_deep_extend("force", _default_opts, opt or {})
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local current_win = vim.api.nvim_get_current_win()

  set_highlight(opt_local)

  ---@type Chowcho.UI.Window[]
  local _wins = {}
  for i, v in ipairs(wins) do
    if not vim.api.nvim_win_is_valid(v) then
      goto continue
    end

    if #opt_local.labels < i then
      vim.notify(
        "The number of windows exceeds the maximum number.\nThe maximum number is determined by the length of the labels array.",
        vim.log.levels.WARN,
        { title = "Chowcho" }
      )
      break
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
      local bufnr, f_win, win = ui.create_floating_win(
        pos.w,
        pos.h,
        v,
        { label = opt_local.labels[i], name = fname },
        opt_local.border_style,
        opt_local.zindex
      )
      vim.api.nvim_set_option_value(
        "winhl",
        "FloatBorder:ChowchoFloatBorder,NormalFloat:ChowchoFloatText",
        { win = f_win }
      )

      if is_enable_icon(opt_local) then
        local line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)
        local icon_col = line[1]:find(icon) - 1
        local end_col = icon_col + vim.fn.strlen(icon)
        vim.api.nvim_buf_add_highlight(bufnr, -1, hl_name, 0, icon_col, end_col)
      end
      table.insert(_float_wins, f_win)
      table.insert(_wins, win)

      if v == current_win then
        vim.api.nvim_set_option_value(
          "winhl",
          "FloatBorder:ChowchoActiveFloatBorder,NormalFloat:ChowchoActiveFloatText",
          { win = f_win }
        )
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
              if v.label == val then
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

chowcho.setup = function(opt)
  if type(opt) == "table" then
    _default_opts = vim.tbl_deep_extend("force", _default_opts, opt)
  else
    error("[chowcho.nvim] option is must be table")
  end
end

return chowcho
