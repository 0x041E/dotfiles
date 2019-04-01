-------------------------------
--  "Huh Yun Mi korean racing model" awesome theme  --
--    By Vit S. (0x041e)   --
-------------------------------

-- {{{ Main
local theme = {}
theme.wallpaper = "/usr/share/awesome/themes/yunmi/yunmi.jpg"
-- }}}

-- {{{ Styles
theme.font      = "sans 8"

-- {{{ Colors
theme.fg_normal  = "#000000"
theme.fg_focus   = "#9C9EA8"
theme.fg_urgent  = "#CC9393"
theme.bg_normal  = "#9C9EA8"
theme.bg_focus   = "#000000"
theme.bg_urgent  = "#FF0000"
theme.bg_systray = theme.bg_normal
-- }}}

-- {{{ Borders
theme.useless_gap   = 0
theme.border_width  = 1
theme.border_normal = "#370943"
theme.border_focus  = "#9C9EA8"
theme.border_marked = "#CC9393"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#333333"
theme.titlebar_bg_normal = "#9C9EA8"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = 15
theme.menu_width  = 100
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = "/usr/share/awesome/themes/yunmi/taglist/squarefz.png"
theme.taglist_squares_unsel = "/usr/share/awesome/themes/yunmi/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = "/usr/share/awesome/themes/default/menu-back.png"
theme.menu_submenu_icon      = "/usr/share/awesome/themes/default/submenu.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = "/usr/share/awesome/themes/yunmi/layouts/tile.png"
theme.layout_tileleft   = "/usr/share/awesome/themes/yunmi/layouts/tileleft.png"
theme.layout_tilebottom = "/usr/share/awesome/themes/yunmi/layouts/tilebottom.png"
theme.layout_tiletop    = "/usr/share/awesome/themes/yunmi/layouts/tiletop.png"
theme.layout_fairv      = "/usr/share/awesome/themes/yunmi/layoujpgfairv.png"
theme.layout_fairh      = "/usr/share/awesome/themes/yunmi/layouts/fairh.png"
theme.layout_spiral     = "/usr/share/awesome/themes/yunmi/layouts/spiral.png"
theme.layout_dwindle    = "/usr/share/awesome/themes/yunmi/layouts/dwindle.png"
theme.layout_max        = "/usr/share/awesome/themes/yunmi/layouts/max.png"
theme.layout_fullscreen = "/usr/share/awesome/themes/yunmi/layouts/fullscreen.png"
theme.layout_magnifier  = "/usr/share/awesome/themes/yunmi/layouts/magnifier.png"
theme.layout_floating   = "/usr/share/awesome/themes/yunmi/layouts/floating.png"
theme.layout_cornernw   = "/usr/share/awesome/themes/yunmi/layouts/cornernw.png"
theme.layout_cornerne   = "/usr/share/awesome/themes/yunmi/layouts/cornerne.png"
theme.layout_cornersw   = "/usr/share/awesome/themes/yunmi/layouts/cornersw.png"
theme.layout_cornerse   = "/usr/share/awesome/themes/yunmi/layouts/cornerse.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = "/usr/share/awesome/themes/yunmi/titlebar/close_focus.png"
theme.titlebar_close_button_normal = "/usr/share/awesome/themes/yunmi/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active  = "/usr/share/awesome/themes/yunmi/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = "/usr/share/awesome/themes/yunmi/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = "/usr/share/awesome/themes/yunmi/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = "/usr/share/awesome/themes/yunmi/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = "/usr/share/awesome/themes/yunmi/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = "/usr/share/awesome/themes/yunmi/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = "/usr/share/awesome/themes/yunmi/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = "/usr/share/awesome/themes/yunmi/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = "/usr/share/awesome/themes/yunmi/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = "/usr/share/awesome/themes/yunmi/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = "/usr/share/awesome/themes/yunmi/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = "/usr/share/awesome/themes/yunmi/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = "/usr/share/awesome/themes/yunmi/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = "/usr/share/awesome/themes/yunmi/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = "/usr/share/awesome/themes/yunmi/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = "/usr/share/awesome/themes/yunmi/titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80