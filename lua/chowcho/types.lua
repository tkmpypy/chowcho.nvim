---@alias Chowcho.BorderStyleType "none"|"single"|"double"|"rounded"|"solid"|"shadow"
---@alias Chowcho.SelectorType "float"|"statusline"

---@class Chowcho.Config.ColorConfig
---@field public active? string
---@field public inactive? string

---@class Chowcho.Config.FloatColorConfig
---@field public label Chowcho.Config.ColorConfig
---@field public text Chowcho.Config.ColorConfig
---@field public border Chowcho.Config.ColorConfig

---@class Chowcho.Config.StatuslineColorConfig
---@field public label Chowcho.Config.ColorConfig
---@field public background Chowcho.Config.ColorConfig

---@class Chowcho.Config.FloatConfig
---@field public icon_enabled boolean
---@field public border_style Chowcho.BorderStyleType
---@field public color Chowcho.Config.FloatColorConfig
---@field public zindex integer

---@class Chowcho.Config.StatuslineConfig
---@field public color Chowcho.Config.StatuslineColorConfig

---@class Chowcho.Config.UI
---@field float Chowcho.Config.FloatConfig
---@field statusline Chowcho.Config.StatuslineConfig

---@class Chowcho.Config.Root
---@field public use_exclude_default boolean
---@field public exclude? fun(buf:integer, win:integer):boolean
---@field public selector Chowcho.Config.UI
---@field public labels string[] @Must be a single character. The length of the array is the maximum number of windows that can be moved.
---@field public selector_style Chowcho.SelectorType

---@alias Chowcho.RunFn fun(fn?:fun(win:integer), opts?:Chowcho.Config.Root)

---@class Chowcho.UI.FloatWinContents
---@field label string
---@field name string

---@class Chowcho.UI.Window
---@field label string
---@field win integer

---@alias Chowcho.UI.ShowFn fun(self, idx: integer, win: integer): Chowcho.UI.Window
---@alias Chowcho.UI.HideFn fun(self)
---@alias Chowcho.UI.HighlightFn fun(self)

---@class Chowcho.UI.Selector
---@field opts Chowcho.Config.Root
---@field public show Chowcho.UI.ShowFn
---@field public hide Chowcho.UI.HideFn
---@field public highlight Chowcho.UI.HighlightFn

---@class Chowcho.UI.SelectManager
---@field public selector? Chowcho.UI.Selector
---@field public show Chowcho.UI.ShowFn
---@field public hide Chowcho.UI.HideFn
---@field public highlight Chowcho.UI.HighlightFn
