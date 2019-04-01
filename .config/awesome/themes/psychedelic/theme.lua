local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local shapes = require("gears.shape")
local gfs = require('gears.filesystem')
local themes_path = gfs.get_themes_dir()

local theme = {}

-- theme.font          = "Droid Sans 6"
-- theme.font          = "Inconsolata 6"
-- theme.font          = "ProFont 8"
theme.font          = "Hack 6"

theme.bg_normal  = "#31363Baa"
theme.bg_focus   = "#579FD6aa"
theme.bg_urgent  = "#3F3F3Faa"
theme.bg_systray = theme.bg_normal

-- theme.bg_normal     = "#222222"
-- theme.bg_focus      = "#535d6c"
-- theme.bg_urgent     = "#ff0000"
-- theme.bg_minimize   = "#444444"
-- theme.bg_systray    = theme.bg_normal

theme.fg_normal  = "#FAFAFA"
-- theme.fg_normal  = "#BAC3CF"
-- theme.fg_focus   = "#F0DFAF"
theme.fg_focus   = "#000000"
theme.fg_urgent  = "#FF0000"

-- theme.fg_normal     = "#aaaaaa"
-- theme.fg_focus      = "#ffffff"
-- theme.fg_urgent     = "#ffffff"
-- theme.fg_minimize   = "#ffffff"

theme.useless_gap   = 0
theme.border_width  = 1

-- local color = require('gears.color')
-- color.parse_color("#000000")
theme.border_normal = "#2f343f"
theme.border_focus  = "#579FD6"
theme.border_marked = "#91231C"

-- theme.tasklist_shape = shapes.powerline
-- theme.taglist_shape = shapes.powerline

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_icon_size = 32

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."psychedelic/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path.."psychedelic/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path.."psychedelic/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path.."psychedelic/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."psychedelic/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."psychedelic/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."psychedelic/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."psychedelic/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."psychedelic/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."psychedelic/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."psychedelic/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."psychedelic/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."psychedelic/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."psychedelic/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."psychedelic/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path.."psychedelic/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_path.."psychedelic/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."psychedelic/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."psychedelic/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path.."psychedelic/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_path.."psychedelic/titlebar/maximized_focus_active.png"

theme.wallpaper = themes_path.."psychedelic/winter-bg.jpg"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."psychedelic/layouts/fairhw.png"
theme.layout_fairv = themes_path.."psychedelic/layouts/fairvw.png"
theme.layout_floating  = themes_path.."psychedelic/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."psychedelic/layouts/magnifierw.png"
theme.layout_max = themes_path.."psychedelic/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."psychedelic/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."psychedelic/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."psychedelic/layouts/tileleftw.png"
theme.layout_tile = themes_path.."psychedelic/layouts/tilew.png"
theme.layout_tiletop = themes_path.."psychedelic/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."psychedelic/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."psychedelic/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."psychedelic/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."psychedelic/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."psychedelic/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."psychedelic/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil
-- local spawn = require('awful.spawn')
-- theme.icon_theme = "/usr/share/icons/Arc"
-- spawn.easy_async("sh -c 'cat .config/gtk-3.0/settings.ini | grep gtk-icon-theme-name= | cut -d= -f2'", function(stdout, stderr, reason, exit_code)
--     theme.icon_theme = theme.icon_theme .. string.sub(stdout,1,-2)
-- end)

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
