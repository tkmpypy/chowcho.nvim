local util = {
  str = {},
  logger = {},
  opt = {},
}

util.str.split = function(str, ts)
  if ts == nil then
    return {}
  end

  local t = {}
  local i = 1
  for s in string.gmatch(str, "([^" .. ts .. "]+)") do
    t[i] = s
    i = i + 1
  end

  return t
end

---@param msg string
---@param level integer
util.logger.notify = function(msg, level)
  vim.notify(msg, level, { title = "Chowcho" })
end

---@param opts Chowcho.Config
---@return boolean
util.opt.is_enable_icon = function(opts)
  if opts.icon_enabled then
    local loaded_devicons = vim.api.nvim_get_var("loaded_devicons")
    if loaded_devicons < 1 then
      return false
    end

    return require("nvim-web-devicons").has_loaded()
  end

  return false
end

return util
