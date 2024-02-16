local util = require("chowcho.util")
local float = require("chowcho.selector.float")
local statusline = require("chowcho.selector.statusline")

---@type Chowcho.SelectManager
local M = {}

M.new = function(opts)
  local obj = {}
  if opts.selector_style == "float" then
    obj.selector = float.new(opts)
  elseif opts.selector_style == "statusline" then
    obj.selector = statusline.new(opts)
  else
    util.logger.notify(string.format("%s is invalid selector type", obj.selector), vim.log.levels.ERROR)
    obj.selector = nil
  end
  setmetatable(obj, { __index = M })

  return obj
end

M.show = function(self, idx, win)
  return self.selector:show(idx, win)
end

M.hide = function(self)
  self.selector:hide()
end

M.highlight = function(self)
  self.selector:highlight()
end

M.pre_proc = function(self)
  if self.selector.integrator ~= nil then
    self.selector.integrator:pre_proc()
  end
end

M.post_proc = function(self)
  if self.selector.integrator ~= nil then
    self.selector.integrator:post_proc()
  end
end

return M
