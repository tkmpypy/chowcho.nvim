local ui = require("chowcho.ui")
local util = require("chowcho.util")
local selector = require("chowcho.selector")

local chowcho = {}

local _float_wins = {}

---@type Chowcho.Config
local _default_opts = {
  icon_enabled = false,
  active_border_color = nil,
  deactive_border_color = nil,
  active_text_color = nil,
  deactive_text_color = nil,
  active_label_color = nil,
  deactive_label_color = nil,
  border_style = "single",
  use_exclude_default = true,
  exclude = nil,
  zindex = 10000,
  labels = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
  selector = "float",
}

---@param opt Chowcho.Config
---@param opt_name string
---@param hl_group_name string
---@param default_hl_int integer
local set_highlight = function(opt, opt_name, hl_group_name, default_hl_int)
  if opt[opt_name] == nil then
    opt[opt_name] = string.format("#%06x", default_hl_int)
  end

  vim.api.nvim_set_hl(0, hl_group_name, {
    fg = opt[opt_name],
  })
end

local set_highlights = function(opt)
  local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
  local float_border_hl = vim.api.nvim_get_hl(0, { name = "FloatBorder" })
  local float_title_hl = vim.api.nvim_get_hl(0, { name = "FloatTitle" })
  local sp_hl = vim.api.nvim_get_hl(0, { name = "Special" })

  set_highlight(opt, "active_border_color", "ChowchoActiveFloatBorder", sp_hl.fg)
  set_highlight(opt, "active_text_color", "ChowchoActiveFloatText", float_title_hl.fg)
  set_highlight(opt, "active_label_color", "ChowchoActiveFloatTitle", normal_hl.fg)
  set_highlight(opt, "deactive_border_color", "ChowchoFloatBorder", float_border_hl.fg)
  set_highlight(opt, "deactive_text_color", "ChowchoFloatText", normal_hl.fg)
  set_highlight(opt, "deactive_label_color", "ChowchoFloatTitle", float_title_hl.fg)
end

    end
  end
end

---@type Chowcho.RunFn
chowcho.run = function(fn, opt)
  local opt_local = vim.tbl_deep_extend("force", _default_opts, opt or {})
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local current_win = vim.api.nvim_get_current_win()

  set_highlights(opt_local)

  ---@type Chowcho.UI.Window[]
  local _wins = {}
  local select_manager = selector.new(opt_local)
  for i, v in ipairs(wins) do
    if not vim.api.nvim_win_is_valid(v) then
      goto continue
    end

    if #opt_local.labels < i then
      util.logger.notify(
        "The number of windows exceeds the maximum number.\nThe maximum number is determined by the length of the labels array.",
        vim.log.levels.WARN
      )
      break
    end

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
    local win_label = select_manager:show(i, v)
    table.insert(_wins, win_label)

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
      select_manager:hide()
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
