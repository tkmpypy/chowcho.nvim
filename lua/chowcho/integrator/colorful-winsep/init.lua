---@type Chowcho.Integrator
local M = {}

M.new = function()
  local obj = {}
  setmetatable(obj, { __index = M })
  return obj
end

M.pre_proc = function(_)
  local ok, winsep = pcall(require, "colorful-winsep")
  if not ok then
    return
  end

  winsep.NvimSeparatorDel()
end
M.post_proc = function(_)
  local ok, winsep = pcall(require, "colorful-winsep")
  if not ok then
    return
  end

  winsep.NvimSeparatorShow()
end

return M
