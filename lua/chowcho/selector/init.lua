local util = require("chowcho.util")
local float = require("chowcho.selector.float")
local winbar = require("chowcho.selector.winbar")

local M = {}

---@param opts Chowcho.Config
---@return Chowcho.UI.SelectManager
M.new = function(opts)
  local obj = {}
  if opts.selector == "float" then
    obj.selector = float.new(opts)
  elseif opts.selector == "winbar" then
    obj.selector = winbar.new(opts)
  else
    util.logger.notify(string.format("%s is invalid selector type", ty), vim.log.levels.ERROR)
    obj.selector = nil
  end
  setmetatable(obj, { __index = M })

  return obj
end

---@type Chowcho.UI.ShowFn
M.show = function(self, idx, win)
  return self.selector:show(idx, win)
end

---@type Chowcho.UI.HideFn
M.hide = function(self)
  self.selector:hide()
end

return M
