---@alias Chowcho.BorderStyleType "none"|"single"|"double"|"rounded"|"solid"|"shadow"

---@class Chowcho.Config
---@field public icon_enabled boolean
---@field public active_border_color? string
---@field public deactive_border_color? string
---@field public active_text_color? string
---@field public deactive_text_color? string
---@field public border_style Chowcho.BorderStyleType
---@field public use_exclude_default boolean
---@field public exclude? fun(buf:integer, win:integer):boolean
---@field public zindex integer
---@field public labels string[] @Must be a single character. The length of the array is the maximum number of windows that can be moved.

---@alias Chowcho.RunFn fun(fn?:fun(win:integer), opts?:Chowcho.Config)

---@class Chowcho.UI.FloatWinContents
---@field label string
---@field name string

---@class Chowcho.UI.Window
---@field label string
---@field win integer
