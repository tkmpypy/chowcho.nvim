local M = {}

---@return Chowcho.UI.Selector
M.new = function()
  local obj = {}
  setmetatable(obj, { __index = M })

  return obj
end

---@param self Chowcho.UI.Selector
M.show = function(self) end

return M
