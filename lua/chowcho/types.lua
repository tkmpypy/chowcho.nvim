---@alias Chowcho.BorderStyleType "none"|"single"|"double"|"rounded"|"solid"|"shadow"
---@alias Chowcho.SelectorType "float"|"winbar"

---@class Chowcho.Config
---@field public icon_enabled boolean
---@field public active_border_color? string
---@field public deactive_border_color? string
---@field public active_text_color? string
---@field public deactive_text_color? string
---@field public active_label_color? string
---@field public deactive_label_color? string
---@field public border_style Chowcho.BorderStyleType
---@field public use_exclude_default boolean
---@field public exclude? fun(buf:integer, win:integer):boolean
---@field public zindex integer
---@field public labels string[] @Must be a single character. The length of the array is the maximum number of windows that can be moved.
---@field public selector Chowcho.SelectorType

---@alias Chowcho.RunFn fun(fn?:fun(win:integer), opts?:Chowcho.Config)

---@class Chowcho.UI.FloatWinContents
---@field label string
---@field name string

---@class Chowcho.UI.Window
---@field label string
---@field win integer

---@alias Chowcho.UI.ShowFn fun(self, idx: integer, win: integer): Chowcho.UI.Window
---@alias Chowcho.UI.HideFn fun(self)

---@class Chowcho.UI.Selector
---@field opts Chowcho.Config
---@field public show Chowcho.UI.ShowFn
---@field public hide Chowcho.UI.HideFn

---@class Chowcho.UI.SelectManager
---@field public selector? Chowcho.UI.Selector
---@field public show Chowcho.UI.ShowFn
---@field public hide Chowcho.UI.HideFn
