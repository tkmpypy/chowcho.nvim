---@type Chowcho.IntegrateManager
local M = {}

M.new = function()
  local obj = {
    integrators = {},
  }
  setmetatable(obj, { __index = M })

  return obj
end

M.pre_proc = function(self)
  for _, integ in ipairs(self.integrators) do
    integ:pre_proc()
  end
end
M.post_proc = function(self)
  for _, integ in ipairs(self.integrators) do
    integ:post_proc()
  end
end

M.register = function(self, intg)
  table.insert(self.integrators, intg)
end

return M
