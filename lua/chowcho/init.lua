local util = require("chowcho.util")
local selector = require("chowcho.selector")

local chowcho = {}

---@type Chowcho.Config.Root
local _default_opts = {
  selector = {
    float = {
      border_style = "single",
      icon_enabled = false,
      color = {
        label = {
          active = nil,
          inactive = nil,
        },
        text = {
          active = nil,
          inactive = nil,
        },
        border = {
          active = nil,
          inactive = nil,
        },
      },
      zindex = 10000,
    },
    statusline = {
      color = {
        label = {
          active = "#fefefe",
          inactive = "#d0d0d0",
        },
        background = {
          active = "#3d7172",
          inactive = "#203a3a",
        },
      },
    },
  },
  labels = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
  ignore_case = false,
  selector_style = "float",
  use_exclude_default = true,
  exclude = nil,
}

---@param wins integer[]
---@return integer[]
local filter_wins = function(wins)
  local ret = {}
  for _, v in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(v)
    local bt = vim.api.nvim_get_option_value("buftype", { buf = buf })
    local fname = vim.fs.basename(vim.api.nvim_buf_get_name(buf))
    if bt == "prompt" then
      goto continue
    elseif bt == "nofile" and fname == "" then
      goto continue
    end

    table.insert(ret, v)
    ::continue::
  end

  return ret
end

---@param a string
---@param b string
---@param ignore_case boolean
local is_match = function(a, b, ignore_case)
  if ignore_case then
    a = string.upper(a)
    b = string.upper(b)
  end

  return a == b
end

---@type Chowcho.RunFn
chowcho.run = function(fn, opt)
  local opt_local = vim.tbl_deep_extend("force", _default_opts, opt or {})

  ---@type integer[]
  local wins = vim.api.nvim_tabpage_list_wins(0)
  if opt_local.use_exclude_default then
    wins = filter_wins(wins)
  end

  if #opt_local.labels < #wins then
    util.logger.notify(
      "The number of windows exceeds the maximum number.\nThe maximum number is determined by the length of the labels array.",
      vim.log.levels.WARN
    )
    return
  end

  ---@type Chowcho.UI.Window[]
  local _wins = {}
  local select_manager = selector.new(opt_local)
  select_manager:pre_proc()
  select_manager:highlight()

  for i, v in ipairs(wins) do
    if not vim.api.nvim_win_is_valid(v) then
      goto continue
    end

    local buf = vim.api.nvim_win_get_buf(v)

    if opt_local.exclude ~= nil then
      if opt_local.exclude(buf, v) then
        goto continue
      end
    end

    local win_label = select_manager:show(i, v)
    table.insert(_wins, win_label)

    ::continue::
  end

  vim.cmd.redraw()

  local success, val = pcall(vim.fn.getchar)
  if success then
    val = vim.fn.nr2char(val)
    if val ~= nil then
      for _, v in ipairs(_wins) do
        if v ~= nil then
          if is_match(v.label, val, opt_local.ignore_case) then
            (fn or vim.api.nvim_set_current_win)(v.win)
          end
        end
      end
    end
  end

  select_manager:hide()
  select_manager:post_proc()

  vim.cmd.redraw()
end

chowcho.setup = function(opt)
  if type(opt) == "table" then
    _default_opts = vim.tbl_deep_extend("force", _default_opts, opt)
  else
    util.logger.notify("option is must be table", vim.log.levels.ERROR)
  end
end

return chowcho
