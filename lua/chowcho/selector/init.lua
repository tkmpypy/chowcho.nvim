local util = require("chowcho.util")
local float = require("chowcho.selector.float")
local statusline = require("chowcho.selector.statusline")

local M = {}

---@param opts Chowcho.Config.Root
---@return Chowcho.UI.SelectManager
M.new = function(opts)
  local obj = {}
  if opts.ui.selector_style == "float" then
    obj.selector = float.new(opts)
  elseif opts.ui.selector_style == "statusline" then
    obj.selector = statusline.new(opts)
  else
    util.logger.notify(string.format("%s is invalid selector type", obj.selector), vim.log.levels.ERROR)
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

---@type Chowcho.UI.HighlightFn
M.highlight = function(self)
  self.selector:highlight()
end

return M
