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

return util
