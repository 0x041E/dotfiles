-- If LuaRocks is installed load packages installed with it
pcall(require, "luarocks.loader")

-- Standard   awesome library
local gears = require("gears")
local awful = require("awful")
-- Async IO stuff
local gio = require("lgi").Gio
-- local lgi = require("lgi")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- local vicious = require("vicious")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Enable VIM help for hotkeys widget when client with matching name is opened:
require("awful.hotkeys_popup.keys.vim")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({ preset = naughty.config.presets.critical,
           title = "Oops, there were errors during startup!",
           text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({ preset = naughty.config.presets.critical,
             title = "Oops, an error happened!",
             text = tostring(err) })
    in_error = false
  end)
end
-- }}}

-- {{{ Variable definitions

-- This is used later as the default terminal and editor to run.
local terminal = "termite"
local webbrowser = "firefox"
local editor = os.getenv("EDITOR") or "nano"
local editor_cmd = terminal .. " -e " .. editor
local chosen_theme = "green"

awful.mouse.snap.client_enabled = false
awful.mouse.snap.edge_enabled = false
-- awful.mouse.snap.default_distance = 5
-- awful.mouse.snap = false
naughty.config.defaults.timeout = 10

-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. chosen_theme .. "/theme.lua")

local dpi = beautiful.xresources.apply_dpi
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
--   awful.layout.suit.spiral,
--   awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  awful.layout.suit.floating,
--   awful.layout.suit.max.fullscreen,
--   awful.layout.suit.magnifier,
--   awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
  local instance = nil

  return function ()
    if instance and instance.wibox.visible then
      instance:hide()
      instance = nil
    else
      instance = awful.menu.clients({ theme = { width = dpi(250) } })
    end
  end
end

local popen = io.popen
local function from_command(cmd)
  local process = popen(cmd, "r")
  if process == nil then
    return ""
  end
  local content = process:read("*a")
  process:close()
  return content
end

local fopen = io.open
local function from_file(file)
  local filep = fopen(file, "r")
  if filep == nil then
    return ""   
  end
  local str = filep:read("*all")
  filep:close()
  return str
end

-- Emit can be daisy-chained
local function emit_signal(self,name,...)
  for k,v in ipairs(self._connections[name] or {}) do
  v(...)
  end
  return self
end

-- Signal conenctions can be daisy-chained
local function connect_signal(self,name,callback)
  self._connections[name] = self._connections[name] or {}
  self._connections[name][#self._connections[name]+1] = callback
  return self
end

local function create_request()
  local req = {_connections={}}
  req.emit_signal = emit_signal
  req.connect_signal = connect_signal
  return req
end

local function file_read(path)
  local req = create_request()
    gio.File.new_for_path(path):load_contents_async(nil, function(file, task, c)
    local content = file:load_contents_finish(task)
    if content then
      req:emit_signal("request::completed", content)
    end
    end)
  return req
end

-- local function trimstring(s)
--   return s:match'^%s*(.*%S)' or ''
-- end

local floor = math.floor
local function round(num, idp)
  local mult = 10^(idp or 0)
  return floor(num * mult + 0.5) / mult
end

-- local function run_once(cmd_arr)
--   for _, cmd in ipairs(cmd_arr) do
--     findme = cmd
--     firstspace = cmd:find(" ")
--     if firstspace then
--       findme = cmd:sub(0, firstspace-1)
--     end
--     awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd))
--   end
-- end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
-- myawesomemenu = {
--  { "hotkeys", function() return false, hotkeys_popup.show_help end},
--  { "manual", terminal .. " -e man awesome" },
--  { "edit config", editor_cmd .. " " .. awesome.conffile },
--  { "restart", awesome.restart },
--  { "quit", function() awesome.quit() end}
-- }
-- 
-- mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
--                   { "open terminal", terminal }
--                   }
--             })
-- 
-- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--                    menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}
-- {{{ Wibar
--{{{ Awesome logo instead of launcher menu
-- local awesomelogo = wibox.widget{
--   image = beautiful.awesome_icon,
--   resize = true,
--   widget = wibox.widget.imagebox
-- }
--}}}
--{{{ Textclock widget
local textclock = wibox.widget.textclock()
textclock:connect_signal("button::press", function()
  awful.spawn("gsimplecal")
end)

local clocktooltip = awful.tooltip({
  timeout = 60, 
  objects = {textclock},
  timer_function = function()
    return "KST: " .. os.date("!%a %b %d %H:%M", os.time() + 9*3600)
  end
})

--}}}
--{{{ Uptime widget
local uptimewidget = awful.widget.watch("uptime -p", 60)
--}}}
--{{{ Brightness widget
-- local brightnesstextbox = wibox.widget.textbox()
-- brightnesstextbox:buttons(gears.table.join(
--               awful.button({}, 1, function()
--                 brightnessslider.visible = not brightnessslider.visible
--               end),
--               awful.button({}, 4, function()
--                 brightnessslider.value = brightnessslider.value + 5
--               end),
--               awful.button({}, 5, function()
--                 brightnessslider.value = brightnessslider.value - 5
--               end)
--               ))
-- 
-- brightnessslider = wibox.widget{
--   widget = wibox.widget.slider,
--   minimum = 1,
--   maximum = 100,
--   handle_shape = gears.shape.circle,
--   handle_color = beautiful.bg_focus,
--   bar_shape = gears.shape.rounded_rect,
--   bar_height = dpi(3),
--   bar_color = beautiful.border_color,
--   forced_width = dpi(50),
--   visible = false,
-- }
-- 
-- brightnessslider:connect_signal("property::value", function(w)
--   awful.spawn.easy_async("sudo wayland-backlight = " .. w['value'], function(stdout, stderr, reason, exit_code)
--     brightnesstextbox:set_markup("💻 " .. math.floor((tonumber(stdout) + 0.5)))
--   end)
-- end)
-- 
-- awful.spawn.easy_async("sudo wayland-backlight", function(stdout, stderr, reason, exit_code)
--   brightnessslider.value = math.floor(tonumber(stdout) + 0.5)
-- end)
-- 
-- brightnesswidget = wibox.widget{
--   brightnessslider,
--   brightnesstextbox,
--   layout = wibox.layout.fixed.horizontal
-- }
--}}}
--{{{ Volume widget
-- local volumetext = wibox.widget.textbox()
-- volumetext:buttons(gears.table.join(
--          awful.button({}, 1, function()
--            volumeslider.visible = not volumeslider.visible
--          end),
--          awful.button({}, 2, function()
--            awful.spawn.easy_async('amixer sset Master toggle', function(stdout, stderr, reason, exit_code)
--              local str = string.match(stdout, '%[%a+%]')
--              if str == "[on]" then
--                volumetext:set_markup("♪ " .. volumeslider.value)
--              else
--                volumetext:set_markup("♬ Muted ("..volumeslider.value .. ")")
--              end
--            end)
--          end),
--          awful.button({}, 3, function()
--            awful.spawn("pavucontrol")
--          end),
--          awful.button({}, 4, function()
--            volumeslider:set_value(volumeslider.value + 5)
--          end),
--          awful.button({}, 5, function()
--            volumeslider:set_value(volumeslider.value - 5)
--          end)
-- ))
--  
-- volumeslider = wibox.widget{
--   widget = wibox.widget.slider,
--   minimum = 5,
--   maximum = 100,
--   handle_shape = gears.shape.circle,
--   handle_color = beautiful.bg_focus,
--   bar_shape = gears.shape.rounded_rect,
--   bar_height = dpi(3),
--   bar_color = beautiful.border_color,
--   forced_width = dpi(50),
--   visible = false
-- }
-- 
-- volumeslider:connect_signal("property::value", function(w)
--  volumetext:set_markup("♪ " .. w['value'])
--  awful.util.spawn_with_shell("amixer sset Master " .. w['value'] .. "%")
-- end)
-- 
-- volumeslider:buttons(gears.table.join(
--          awful.button({}, 4, function()
--            volumeslider:set_value(volumeslider.value + 5)
--          end),
--          awful.button({}, 5, function()
--            volumeslider:set_value(volumeslider.value - 5)
--          end)
--          ))
-- 
-- awful.spawn.easy_async('amixer sget Master', function(stdout, stderr, reason, exit_code)
-- --   naughty.notify({ text = string.match(stdout, '(%d+)%%')})
--   volumeslider.value = tonumber(string.match(stdout, '(%d+)%%'))
-- end)
-- 
-- -- awful.spawn.with_line_callback("pactl subscribe", {
-- --   stdout = function(stdout)
-- --     local event = stdout:match("%'(%a+)%'")
-- --     naughty.notify({ text = event })
-- --     if event == "change" then
-- --       awful.spawn.easy_async('amixer sget Master', function(stdout, stderr, reason, exit_code)
-- --   --       volumeslider.value = string.match(stdout, '(%d+)%%')
-- --         naughty.notify({ text = stdout })
-- --       end)
-- --     end
-- --   end,
-- --   stderr = function(stderr)
-- --     naughty.notify({ text = stderr })
-- --   end,
-- -- })
-- 
-- -- volumetext:set_markup("♪ " .. volumeslider.value)
-- -- on slider value change change volume
-- 
-- local volumewidget = wibox.widget {
--  volumeslider,
--  volumetext,
--  layout = wibox.layout.fixed.horizontal
-- }
--}}}
--{{{ Gmail notification
-- local receivedmails=0
-- -- local mailcount=tonumber(from_command("~/.config/awesome/check_mail.sh"))
-- local mailcount = 0xffffffff
-- local color="<span>"
-- local gmailwidget = wibox.widget.textbox()
-- gmailwidget:set_markup("🖂 ")
-- -- gmailtooltip = awful.tooltip({
-- --    timeout = 60,
-- --    objects = {gmailwidget},
-- --    timer_function = function() return from_command("~/.config/awesome/check_mail.sh --mails") end
-- --  })
-- local gmailtimer = gears.timer({ timeout = 30 })
-- gmailtimer:connect_signal("timeout", function() 
--   awful.spawn.easy_async("sh -c ~/.config/awesome/check_mail.sh", function(stdout, stderr, reason, exit_code)
--     if stdout == "" then
--       return
--     end
-- 
--     local mails=tonumber(stdout)
--     if mails ~= mailcount then
--     receivedmails=mails-mailcount > 0 and mails-mailcount or 0
--       if receivedmails > 0 then
--         color = "<span color=\"" .. beautiful.fg_urgent .. "\">"
--         awful.spawn.easy_async("sh -c '~/.config/awesome/check_mail.sh --mails'", function(stdout, stderr, reason, exit_code)
--           local nl = string.find(stdout, '\n')
--           local nl2 = string.find(stdout, '\n', nl+1)
-- --         string.sub(stdout, 1, nl-1)
--           naughty.notify({ title = "Gmail" , text = string.sub(stdout, nl+1, nl2-1), timeout = 15 })
--         end)
--       else
--         color = "<span>"
--       end
--     mailcount = mails
--     end
--     gmailwidget:set_markup(color .. "🖂 </span>")
--   end)
-- end)
-- gmailtimer:start()
--}}}
-- --{{{ Cpu widgets
--{{{ Cpu widgets variables initialization
-- local cpu_maxtemp=70
-- local cpufreqcounter = 0
-- local cpufreqarr = {}
-- local freqarrsize=1
-- -- Initial value later updated with actual corecount
-- local cpucores = 2
-- 
-- --save 20 samples per each core
-- -- set array size and fill the array so that calculation of frequency doesn't
-- -- fail on nil value

--}}}
-- --{{{ Cpu temperature widget
-- local cputempwidget = wibox.widget.textbox()
-- local cputemptooltip = awful.tooltip({
--   objects = { cputempwidget },
--   --shape = gears.shape.octogon,
--   timer_function = function()
--     local str = ""
--     for i=1, cpucores do
--       str = str .. "Core" .. i .. ": " .. tonumber(from_file('/sys/class/thermal/thermal_zone' .. i .. '/temp') / 1000) .. "°C\n"
--     end
--     return string.sub(str,1,-2)
--   end,
--   timeout = 1
-- })
-- 
-- local cpu_lasttemp=0
-- local cputempwidgettimer = gears.timer({ timeout=1 })
-- cputempwidgettimer:connect_signal("timeout", function()
-- --   local request = file_read("/sys/class/thermal/thermal_zone1/temp")
--   local request = file_read("/sys/bus/platform/devices/coretemp.0/hwmon/hwmon0/temp1_input")
--   request:connect_signal("request::completed", function(content)
--     if tonumber(content) == cpu_lasttemp then return; end
--     cpu_lasttemp=gears.math.round(content) -- math.tointeger()
--     local tempstr = ""
--     local temp = gears.math.round(content / 1000) --math.floor((tonumber(content) / 1000) + 0.5)
-- --     naughty.notify({ text = tostring(temp) })
--     tempstr = (temp < cpu_maxtemp) and ("🌡 " .. temp .. " °C") or ("🌡 <span color='#FF0000'>" .. temp .. "°C</span>")
--     cputempwidget:set_markup(tempstr)
-- --     naughty.notify({ text = "completed" })
--   end)
-- end)
-- --   cputempwidget:set_markup(cputemp()) end)
-- cputempwidgettimer:emit_signal("timeout")
-- cputempwidgettimer:start()
--}}}
--{{{ Cpu frequency widget
-- local function cpufreq(core, i)
--   -- Frequency in MHz
--   local request = file_read("/sys/devices/system/cpu/cpufreq/policy" .. core .. "/scaling_cur_freq")
--   request:connect_signal("request::completed", function(content)
--     cpufreqarr[i] = tonumber(content)
--   end)
-- end
-- 
-- local function updatecpufreq()
--   local averageclock = 0
--   for i=1, freqarrsize do
--     averageclock = averageclock + cpufreqarr[i]
--   end
--   averageclock = averageclock / freqarrsize
--   averageclock = averageclock>=1000000 and (tostring(round(averageclock/1000000, 1)) .. " GHz") or (tostring(gears.math.round(averageclock/1000)) .. " MHz")
-- 
--   return averageclock
-- end
-- 
-- local function cpufreqstr()
--   return "<span> " .. updatecpufreq() .. "</span>"
-- --   return "<span underline='low' underline_color=\'" .. beautiful.border_focus .. "\'> " .. updatecpufreq() .. "</span>"
--   -- return " " .. string.format("%7s", updatecpufreq())
-- end
-- 
-- local cpufreqwidget = wibox.widget{
--   widget = wibox.widget.textbox(),
-- --   force_width = dpi(50)
-- }
-- local cpufreqwidgettimer = gears.timer({ timeout=0.1 })
-- cpufreqwidgettimer:connect_signal("timeout", function()
--   for i=0, cpucores-1 do
--     cpufreq(i,(cpufreqcounter % freqarrsize) + 1)
--     cpufreqcounter = cpufreqcounter + 1
--   end
-- 
--   if cpufreqcounter % freqarrsize == 0 then
--     cpufreqwidget:set_markup(cpufreqstr())
-- --     cpufreqwidget:set_markup(cpufreqstr())
--   end
-- end)
-- 
-- local cpufreqwidgettooltip = awful.tooltip({
--   objects = { cpufreqwidget },
--   timer_function = function()
--     local str = ""
--     for i=1,cpucores do
--       local avg = 0
--       for j=i, freqarrsize, cpucores do
--         avg = avg + cpufreqarr[j]
--       end
--       avg = avg / (freqarrsize / cpucores)
--       avg = avg>=1000000 and (tostring(round(avg/1000000, 1)) .. " GHz") or (tostring(math.floor(avg/1000)) .. " MHz")
--       str = str .. "Core " .. i .. ": " .. avg .. "\n"
--     end
--     str = str .. from_command('cut -z -f-3 -d" " /proc/loadavg')
--     return string.sub(str,1,-2)
--   end,
--   timeout = 1
--  })
-- 
-- awful.spawn.easy_async("sh -c 'ls -d /sys/devices/system/cpu/cpu[0-9]* | wc -l'", function(stdout, stderr, reason, exitcode)
-- -- Initialize variables and load system core count and after initializing everything start timers to load info into widget
--   cpucores = tonumber(stdout)
--   freqarrsize=20*cpucores
--   for i=freqarrsize, 1, -1 do
--     cpufreqarr[i] = 0
--   end
--   cpufreqwidgettimer:start()
--   cpufreqwidget:set_markup(cpufreqstr())
-- --   cpufreqwidget:set_markup(cpufreqstr())
-- end)
-- 
--}}}
--{{{ Cpu usage widget
-- local cpuwidget = awful.widget.graph()
-- cpuwidget:set_width(50)
-- cpuwidget:set_height(20)
-- --cpuwidget:set_border_color(beautiful.border_focus)
-- cpuwidget:set_background_color(beautiful.bg_systray)
-- cpuwidget:set_color({ type = "linear", from = { 0, 0 }, to = { 0, 20}, stops = { {0, "#FF0000"}, { 20, "#00FF00" } } })
-- local cpuloadtooltip = awful.tooltip({
--   objects = {cpuwidget},
--   --shape = gears.shape.infobubble,
--   timer_function = function()
--     return from_command('cut -z -f-3 -d" " /proc/loadavg')
--   end,      
--   timeout = 10,   
-- })
-- local cpuwidgettimer = gears.timer({  timeout = 1,
--                                       autostart = true,
--                                       callback = function()
--                                         awful.spawn.easy_async("sh -c 'cat /proc/loadavg | cut -z -d\" \" -f1'", function(stdout, stderr, reason, exit_code)
--                                           naughty.notify({ text = stdout })
--                                           cpuwidget:add_value(tonumber(stdout))
--                                         end)
--                                       end
--                                   })
-- -- Register widget  
-- vicious.register(cpuwidget, vicious.widgets.cpu, "$1")
--}}}
-- --}}}
-- {{{ Network speed widget
-- local updownwidget = wibox.widget.textbox()
-- local networktimer = gears.timer({ timeout = 1 })
-- local networkprevvalue = 0
-- networktimer:connect_signal("timeout", function()
--     local request = file_read("/proc/net/dev")
--     request:connect_signal("request::completed", function(content)
-- --         naughty.notify({ text = 'network' })
--         if content then
--           local match = string.match(content,"wlp3s0:%s*(%d+)")
--           updownwidget:set_markup(tostring(round((tonumber(match)-networkprevvalue)/1024,1)) .. " kB/s")
--           networkprevvalue = tonumber(match)
--         end
--       end)
--   end)
-- networktimer:emit_signal("timeout")
-- networktimer:start()
-- }}}
--{{{ Battery widget
--{{{ Battery variables init
local batteryupdatetimer = gears.timer({ timeout = 15 })
local batterybar =  wibox.widget{
          max_value = 100,
          min_value = 0,
--            value = tonumber(battery_level()),
          bg = nil,
          colors = { beautiful.border_focus },
          start_angle = math.pi + math.pi/2,
          thickness = 2,
          widget = wibox.container.arcchart,
        }
local batterytext = wibox.widget{
  widget = wibox.widget.textbox,
  -- vertical and horizontal align to center of the arc
  align = 'center',
  valign = 'center',
--   font = "Hack 5",
}

local lowbattlevel = {}
-- lowbattlevel[4] = function()            
--   --no battery so power off system before power cuts off
--   os.execute("systemctl poweroff")
-- end                         

lowbattlevel[7] = 1
lowbattlevel[10] = 1
lowbattlevel[15] = 1
lowbattlevel[25] = function()
  batterybar.colors = { beautiful.fg_urgent }
--   naughty.notify({ text = "Urgent", preset = naughty.config.presets.critical })
end
lowbattlevel[26] = function()
  batterybar.colors = { beautiful.border_focus }
--   naughty.notify({ text = "Urgent" })
end
local lastlevel = 101
local batterystatus = ""
local batterypath = ""
--}}}

local batterywidget = wibox.widget {
  batterybar,
  batterytext,
  layout = wibox.layout.stack,
}

--batterybar:set_color({type="linear", from = {0, 0}, to = {50, 0}, stops = { {0, "#AA0000"}, {1.0, beautiful.border_focus} } })
local batterytooltip = awful.tooltip({
  objects = {batterywidget},
  text = string.sub(from_command("acpi"), 1, -2),
  timer_function = function()
    return string.sub(from_command("acpi"), 1, -2)
  end,
  timeout = 5,
})
                          
-- Low battery warning notification           
batteryupdatetimer:connect_signal("battery::charge_changed", function(parent_object, charge)
--   if batterystatus == "Discharging\n" then
--     naughty.notify({ text = tostring(charge) })
    local step = lastlevel > charge and -1 or 1
    for i = lastlevel,charge,step do
--       naughty.notify({ text = "i: " .. i })
      if lowbattlevel[i] then   
        if type(lowbattlevel[i]) ~= "function" then
          naughty.notify({
          preset = naughty.config.presets.critical,
          title = "Battery",
          text = "Battery level low " .. tostring(charge) .. "%"
        })
        else            
--           naughty.notify({ text = "Executing function" })
          lowbattlevel[i]()
        end
      end               
    end 
--   end
  lastlevel = charge
end)

batteryupdatetimer:connect_signal("timeout",    
  -- update battery status (discharging/charging/offline)
  function()                  
    local request = file_read(batterypath .. "/status")
      request:connect_signal("request::completed", function(content)
      batterystatus = content
    end)

  -- update current battery charge level
  local request = file_read(batterypath .. "/capacity")
  request:connect_signal("request::completed", function(filecontent)
    local batterylevel = tonumber(filecontent)
    --  naughty.notify({ text = tostring(batterylevel) })
    if lastlevel ~= batterylevel  then
      batterybar:set_value(batterylevel)
      -- use the original string instead of batterylevel to save conversion
      if batterylevel < 100 then
        batterytext:set_markup(filecontent)
      else
        batterytext:set_markup("")
      end
      batteryupdatetimer:emit_signal("battery::charge_changed", batterylevel)
    end
  end)
end)

-- Load up battery path and start all the timers for widget updates
awful.spawn.easy_async("sh -c 'ls -d /sys/class/power_supply/BAT*'", function(stdout)
  batterypath = string.sub(stdout,1,-2)
  batteryupdatetimer:emit_signal("timeout")
  batteryupdatetimer:start()
end)
--}}}
--{{{ Kr vocab widget
local vocabwidget = awful.widget.button({ image = "/usr/share/icons/Flattr/apps/64/empathy.svg" })
vocabwidget:connect_signal("button::press", function() awful.util.spawn_with_shell(terminal .. ' -e "less /home/vitis/Documents/kr_vocab.txt"') end )
--}}}
--{{{ Music player widget
local musicwidget = awful.widget.button({ image = "/usr/share/icons/Flattr/apps/64/google-play-music.svg" })
-- detect cmus on startup
awful.spawn.easy_async("pgrep cmus", function(stdout)
  if stdout ~= "" then
    musicwidgetcontrols.visible = true
    musictracktimer:emit_signal("timeout")
    musictracktimer:start()
    musictrackscroller:continue()
  end
end)

musicwidget:connect_signal("button::press", function() 
  awful.spawn.easy_async("pgrep cmus", function(stdout)
    if stdout == "" then
      -- cmus not running
      awful.util.spawn_with_shell(terminal .. " -e cmus")
      musicwidgetcontrols.visible = true
--       musictracktimer:emit_signal("timeout")
      musictracktimer:start()
      musictrackscroller:continue()
    else
      --cmus running
      awful.util.spawn("cmus-remote -C quit")
      musicwidgetcontrols.visible = false
      musictracktimer:stop()
      musictrackscroller:pause()
    end
  end)
end)

local themedir = beautiful.icon_theme or "/usr/share/icons/Arc"
local musicprev = awful.widget.button({ image = themedir .. "/actions/24/media-skip-backward.png" })
musicprev:connect_signal("button::press", function() awful.util.spawn_with_shell("cmus-remote -r") end)
local musicpause = awful.widget.button({ image = themedir .. "/actions/24/media-playback-pause.png" })
musicpause:connect_signal("button::press", function() awful.util.spawn_with_shell("cmus-remote -u") end)
-- local musicplay = awful.widget.button({ image = themedir .. "/actions/24/media-playback-start.png" })
-- musicplay:connect_signal("button::press", function() awful.util.spawn_with_shell("cmus-remote -u") end)
local musicnext = awful.widget.button({ image = themedir .. "/actions/24/media-skip-forward.png" })
musicnext:connect_signal("button::press", function() awful.util.spawn_with_shell("cmus-remote -n") end)
local musictrack = wibox.widget.textbox()
musictracktimer = gears.timer({ timeout = 2 })
musictracktimer:connect_signal("timeout", function()
  awful.spawn.easy_async("cmus-remote -Q", function(stdout)
      local artist = string.match(stdout, 'tag artist ([^%c]+)')
      local track = string.match(stdout, 'tag title ([^%c]+)')
      if artist == nil and track == nil then
        -- if both artist and track name fail parsing use filename for song name
        local match = string.match(stdout, '[^/]/([^/]-)%.%a+')
        if match == nil then
          musicwidgetcontrols.visible = false
          musictracktimer:stop()
          musictrackscroller:pause()
          return
        end
        musictrack:set_markup(match)
        return
      end
      musictrack:set_markup(artist .. ' - ' .. track)
--     for match in string.gmatch(stdout, '[^/]/([^/]+) ') do
--       musictrack:set_markup(match)
--     end
  end)
end)
musictrackscroller = wibox.widget{
            layout = wibox.container.scroll.horizontal,
            max_size = 100,
            step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
            speed = 50,
            {
              widget = musictrack,
            },
          }

musicwidgetcontrols = wibox.widget {
          musicprev,
          musicpause,
          musicnext,
          musictrackscroller,
          visible = false,
          layout = wibox.layout.fixed.horizontal
        }
--}}}
--{{{ UPDATES AVAILABLE WIDGET
local updaterstatus = wibox.widget.textbox()
local updatetimer = gears.timer({ timeout = 10 })
updatetimer:connect_signal("timeout", function()
    awful.spawn.easy_async("pgrep pacaur", function(stdout)
      if stdout == "" then
        updaterstatus:set_markup("")
        updatetimer:stop()
      end
    end)
  end)
local updaterwidget = wibox.widget.imagebox()
updaterwidget:set_image("/usr/share/icons/gnome/24x24/actions/up.png")
-- updaterwidget:set_image("/home/vitis/Pictures/ba5ef9ebf19c9a2cabf55967410267a0276223ce.gif")
updaterwidget:buttons(gears.table.join( 
          awful.button({}, 1, function()
            if from_command("pgrep pacman") == "" then
              awful.util.spawn_with_shell("sudo /usr/bin/pacman -Sy")
              updaterstatus:set_markup("Syncing...")
              updatetimer:start()
            end
          end
          )
        ))
                          
local updatertooltip = awful.tooltip({        
  objects = {updaterwidget},          
  timer_function = function()           
    local packages = from_command("yaourt -Qu");--from_command('pacman -Qu | grep -v [[ignored]]')
    if packages == "" then          
      packages = "System is up to date"
    else                    
      packages = string.sub(packages, 1, -2)
    end                     
    return packages
  end,                      
  timeout = 500,              
})
--}}}  

--{{{ Widget separator
local widgetseparator = wibox.widget.textbox()
widgetseparator:set_markup(" | ")

local widgetspacer = wibox.widget.textbox()
widgetspacer:set_markup(" ")
--}}}

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
            awful.button({ }, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1, function(t)
                          if client.focus then
                            client.focus:move_to_tag(t)
                          end
                        end),
            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                          if client.focus then
                            client.focus:toggle_tag(t)
                          end
                        end),
            awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
          )

local tasklist_buttons = gears.table.join(
            awful.button({ }, 1, function (c)
              if c == client.focus then
                c.minimized = true
              else
              -- Without this, the following
              -- :isvisible() makes no sense
              c.minimized = false
              if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
              end
              -- This will also un-minimize
              -- the client, if needed
              client.focus = c
              c:raise()
              end
            end),
            awful.button({ }, 2, function(c) c.sticky = not c.sticky; end),
            awful.button({ }, 3, client_menu_toggle_fn()),
            awful.button({ }, 4, function ()
                   awful.client.focus.byidx(1)
                   end),
            awful.button({ }, 5, function ()
                   awful.client.focus.byidx(-1)
                   end),
            awful.button({ }, 8, function(c) c:kill(); end))

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.fit(wallpaper, s, beautiful.background_color)
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  set_wallpaper(s)

  -- Each screen has its own tag table.
  --, "7", "8", "9" },
  awful.tag({ "IRC", "Web", "Emails", "Docs", "Music", "Other"}, s, awful.layout.layouts[1])

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
               awful.button({ }, 1, function () awful.layout.inc( 1) end),
               awful.button({ }, 3, function () awful.layout.inc(-1) end),
               awful.button({ }, 4, function () awful.layout.inc( 1) end),
               awful.button({ }, 5, function () awful.layout.inc(-1) end)))
  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

  -- Create the wibox
  s.mywibox = awful.wibar({ position = "top", screen = s })

  -- Add widgets to the wibox
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
--       mylauncher,
      s.mytaglist,
      s.mypromptbox,
    },
    s.mytasklist, -- Middle widget
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
--       awesomelogo,
      textclock,
      --widgetseparator,
      uptimewidget,
--       widgetspacer,
--       widgetseparator,
--       gmailwidget,
--       widgetseparator,
--       cputempwidget,
--       widgetseparator,
--       brightnesswidget,
--       widgetseparator,
--       volumewidget,
--       widgetseparator,
--       cpufreqwidget,
-- --       cpuwidget,
--       widgetseparator,
--       updownwidget,
      widgetspacer,
      batterywidget,
      vocabwidget,
      musicwidget,
      musicwidgetcontrols,
      updaterwidget,
      updaterstatus,
      wibox.widget.systray(),
      s.mylayoutbox,
    },
  }
end)
-- }}}

-- {{{ Mouse bindings
-- root.buttons(gears.table.join(
--   awful.button({ }, 1, function () mymainmenu:hide() end),
--   awful.button({ }, 3, function () mymainmenu:toggle() end),
--   awful.button({ }, 4, awful.tag.viewnext),
--   awful.button({ }, 5, awful.tag.viewprev)
-- ))
-- }}}

-- {{{ Key bindings
local globalkeys = gears.table.join(
  awful.key({ modkey,       }, "s",    hotkeys_popup.show_help,
        {description="show help", group="awesome"}),
  --awful.key({ modkey,       }, "Left",   awful.tag.viewprev,
  --      {description = "view previous", group = "tag"}),
  --awful.key({ modkey,       }, "Right",  awful.tag.viewnext,
  --      {description = "view next", group = "tag"}),
  awful.key({ modkey,       }, "Escape", awful.tag.history.restore,
        {description = "go back", group = "tag"}),

  awful.key({ modkey,       }, "j",
    function ()
      awful.client.focus.byidx( 1)
    end,
    {description = "focus next by index", group = "client"}
  ),
  awful.key({ modkey,       }, "k",
    function ()
      awful.client.focus.byidx(-1)
    end,
    {description = "focus previous by index", group = "client"}
  ),
--   awful.key({ modkey, "Shift"   }, "w", function () mymainmenu:show() end,
--         {description = "show main menu", group = "awesome"}),

  -- Layout manipulation
  awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)  end,
        {description = "swap with next client by index", group = "client"}),
  awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)  end,
        {description = "swap with previous client by index", group = "client"}),
  awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
        {description = "focus the next screen", group = "screen"}),
  awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
        {description = "focus the previous screen", group = "screen"}),
  awful.key({ modkey,       }, "u", awful.client.urgent.jumpto,
        {description = "jump to urgent client", group = "client"}),
  awful.key({ modkey,       }, "Tab",
    function ()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end,
    {description = "go back", group = "client"}),

  -- Standard program
  awful.key({ modkey, "Shift"   }, "Return", function () awful.spawn(terminal) end,
        {description = "open a terminal", group = "launcher"}),
  awful.key({ modkey, "Control" }, "r", awesome.restart,
        {description = "reload awesome", group = "awesome"}),
  awful.key({ modkey, "Shift"   }, "q", awesome.quit,
        {description = "quit awesome", group = "awesome"}),

  awful.key({ modkey,       }, "l",   function () awful.tag.incmwfact( 0.05)      end,
        {description = "increase master width factor", group = "layout"}),
  awful.key({ modkey,       }, "h",   function () awful.tag.incmwfact(-0.05)      end,
        {description = "decrease master width factor", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "h",   function () awful.tag.incnmaster( 1, nil, true) end,
        {description = "increase the number of master clients", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "l",   function () awful.tag.incnmaster(-1, nil, true) end,
        {description = "decrease the number of master clients", group = "layout"}),
  awful.key({ modkey, "Control" }, "h",   function () awful.tag.incncol( 1, nil, true)  end,
        {description = "increase the number of columns", group = "layout"}),
  awful.key({ modkey, "Control" }, "l",   function () awful.tag.incncol(-1, nil, true)  end,
        {description = "decrease the number of columns", group = "layout"}),
  awful.key({ modkey,       }, "space", function () awful.layout.inc( 1)        end,
        {description = "select next", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)        end,
        {description = "select previous", group = "layout"}),

  awful.key({ modkey, "Control" }, "n",
        function ()
          local c = awful.client.restore()
          -- Focus restored client
          if c then
            client.focus = c
            c:raise()
          end
        end,
        {description = "restore minimized", group = "client"}),

  -- Prompt
  awful.key({ modkey },      "r",   function () awful.screen.focused().mypromptbox:run() end,
        {description = "run prompt", group = "launcher"}),

  awful.key({ modkey }, "x",
        function ()
          awful.prompt.run {
          prompt     = "Run Lua code: ",
          textbox    = awful.screen.focused().mypromptbox.widget,
          exe_callback = awful.util.eval,
          history_path = awful.util.get_cache_dir() .. "/history_eval"
          }
        end,
        {description = "lua execute prompt", group = "awesome"}),
  -- Menubar
  awful.key({ modkey }, "p", function() menubar.show() end,
        {description = "show the menubar", group = "launcher"}),

  -- My programs
  awful.key({ modkey, "Shift"   }, "a", function () awful.util.spawn_with_shell("xrandr --output LVDS1 --auto --gamma 1:1:1") end),
  awful.key({ modkey,       }, "w", function () awful.spawn(webbrowser, { tag = mouse.screen.selected_tag }) end),
  awful.key({ modkey, "Shift"    }, "f", function () awful.util.spawn_with_shell(terminal .. " -e ranger") end),
  awful.key({ "Control",       }, "Print", nil, function () awful.util.spawn_with_shell("scrot -u -e 'mv $f ~/Pictures/Screenshots/'") end),
  awful.key({           }, "Print", nil, function () awful.util.spawn_with_shell("scrot -e 'mv $f ~/Pictures/Screenshots/'") end),
  awful.key({           }, "XF86TouchpadToggle", function () awful.util.spawn_with_shell("touchpad_toggle") end),
  awful.key({ modkey,       }, "F2" , function ()
    --awful.util.spawn("i3lock-fancy -- scrot")
    awful.util.spawn_with_shell("xset s activate")
--     awful.spawn("light-locker-command -l")
--     awful.util.spawn_with_shell("dbus-send --type=method_call --dest=org.gnome.ScreenSaver /org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock")
  end),
  --awful.key({ modkey,       }, "F2" , function () awful.util.spawn_with_shell("i3lock-fancy -- scrot") end),
  --awful.key({ modkey,       }, "F2" , function () awful.util.spawn_with_shell("pkill compton || compton --force-win-blend") end),
  awful.key({ modkey,       }, "F3" , function ()
--     awful.spawn("xbacklight -10")
    awful.spawn("sudo wayland-backlight -10")
--     brightnessslider.value = brightnessslider.value - 10
  end),
  awful.key({ modkey,       }, "F4" , function () 
--     awful.spawn("xbacklight +10")
    awful.spawn("sudo wayland-backlight 10")
--     brightnessslider.value = brightnessslider.value + 10
  end),
  -- Music player
  awful.key({}, "XF86AudioPlay", function () awful.util.spawn_with_shell("pgrep cmus || " .. terminal .. "   -e cmus && cmus-remote -u") end),
  awful.key({modkey,      }, "F5", function () awful.util.spawn_with_shell("pgrep cmus || " .. terminal .. " -e cmus && cmus-remote -u") end),

  awful.key({}, "XF86AudioStop", function () awful.util.spawn_with_shell("cmus-remote -s") end),
  awful.key({modkey,      }, "F8", function () awful.util.spawn_with_shell("cmus-remote -s") end),


  awful.key({}, "XF86AudioNext", function () awful.util.spawn_with_shell("cmus-remote -n") end),
  awful.key({modkey,      }, "F7", function () awful.util.spawn_with_shell("cmus-remote -n") end),

  awful.key({}, "XF86AudioPrev", function () awful.util.spawn_with_shell("cmus-remote -r") end),
  awful.key({modkey,      }, "F6", function () awful.util.spawn_with_shell("cmus-remote -r") end),

  awful.key({}, "XF86MonBrightnessUp", function ()
--     awful.spawn("xbacklight +10")
    awful.spawn("sudo wayland-backlight 10")
  end),
  awful.key({}, "XF86MonBrightnessDown", function ()
--     awful.spawn("xbacklight -10")
    awful.spawn("sudo wayland-backlight -10")
  end)

  -- System binds
--   awful.key({}, "XF86MonBrightnessUp", function ()
--     brightnessslider.value = brightnessslider.value + 10
--   end),
--   awful.key({}, "XF86MonBrightnessDown", function ()
--     brightnessslider.value = brightnessslider.value - 10
--   end),

--   awful.key({}, "XF86AudioRaiseVolume", function ()
--    volumeslider.value = volumeslider.value + 5
--   end),
--   awful.key({}, "XF86AudioLowerVolume", function ()
--     volumeslider.value = volumeslider.value - 5
--   end),
--   awful.key({}, "XF86AudioMute", function ()
--    awful.util.spawn_with_shell("amixer sset Master toggle")
--   end)
)

local clientkeys = gears.table.join(
  awful.key({ modkey,       }, "f",
    function (c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    {description = "toggle fullscreen", group = "client"}),
  awful.key({ modkey,       }, "q",    function (c) c:kill()             end,
        {description = "close", group = "client"}),
  awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle           ,
        {description = "toggle floating", group = "client"}),
  awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
        {description = "move to master", group = "client"}),
  awful.key({ modkey,       }, "o",    function (c) c:move_to_screen()         end,
        {description = "move to screen", group = "client"}),
  awful.key({ modkey,       }, "t",    function (c) c.ontop = not c.ontop      end,
        {description = "toggle keep on top", group = "client"}),
  awful.key({ modkey,       }, "n",
    function (c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
    end ,
    {description = "minimize", group = "client"}),
  awful.key({ modkey,       }, "m",
    function (c)
      c.maximized = not c.maximized
      c:raise()
      if c.maximized then
        c.border_width = 0
      else
        c.border_width = beautiful.border_width
      end
    end ,
    {description = "maximize", group = "client"}),
  awful.key({ modkey, "Control" }, "m",
    function (c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end ,
    {description = "(un)maximize vertically", group = "client"}),
  awful.key({ modkey, "Shift"   }, "m",
    function (c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end ,
    {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9,
          function ()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
               tag:view_only()
            end
          end,
          {description = "view tag #"..i, group = "tag"}),
    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9,
          function ()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
             awful.tag.viewtoggle(tag)
            end
          end,
          {description = "toggle tag #" .. i, group = "tag"}),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
          function ()
            if client.focus then
              local tag = client.focus.screen.tags[i]
              if tag then
                client.focus:move_to_tag(tag)
              end
           end
          end,
          {description = "move focused client to tag #"..i, group = "tag"}),
    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
          function ()
            if client.focus then
              local tag = client.focus.screen.tags[i]
              if tag then
                client.focus:toggle_tag(tag)
              end
            end
          end,
          {description = "toggle focused client on tag #" .. i, group = "tag"})
  )
end

local clientbuttons = gears.table.join(
  awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  { rule = { },
    properties = { border_width = beautiful.border_width,
                   border_color = beautiful.border_normal,
                   focus = awful.client.focus.filter,
                   raise = true,
                   keys = clientkeys,
                   buttons = clientbuttons,
                   screen = awful.screen.preferred,
                   placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                   size_hints_honor = false,
--                  shape_bounding=gears.shape.rounded_rect,
--                  shape_clip=gears.shape.rounded_rect
   }
  },

  -- Floating clients.
  { rule_any = {
    instance = {
      "DTA",  -- Firefox addon DownThemAll.
      "copyq",  -- Includes session name in class.
    },
    class = {
      "Arandr",
      "Gpick",
      "Kruler",
      "MessageWin",  -- kalarm.
      "Sxiv",
      "Wpa_gui",
      "pinentry",
      "veromix",
      "xtightvncviewer",
      "gimp",
      "/usr/lib/firefox/plugin-container" },

    name = {
      "Event Tester",  -- xev.
      "Emoji Choice", -- Ibus emoji choose window
    },
    role = {
      "AlarmWindow",  -- Thunderbird's calendar.
      "pop-up",     -- e.g. Google Chrome's (detached) Developer Tools.
    }
    }, properties = { floating = true }},

  -- Add titlebars to normal clients and dialogs
  { rule_any = {type = { "normal", "dialog" }
    }, properties = { titlebars_enabled = false }
  },
--   { rule_any = { class = { "mpv" }
--   }, properties = { border_width = 0 } },
--   { rule_any = { class = { "geary", "Geary" }
--   }, properties = { tag = "Emails" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup and
    not c.size_hints.user_position
    and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
  end
end)

-- client.connect_signal("property::floating", function(c)
--   naughty.notify({ text = "Floating" })
--   if c.floating then
--     c:emit_signal("request::titlebars")
--   else
--     c.titlebar:hide()
--   end
-- end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = gears.table.join(
    awful.button({ }, 1, function()
      client.focus = c
      c:raise()
      awful.mouse.client.move(c)
    end),
    awful.button({ }, 3, function()
      client.focus = c
      c:raise()
      awful.mouse.client.resize(c)
    end)
  )

  awful.titlebar(c) : setup {
    { -- Left
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout  = wibox.layout.fixed.horizontal
    },
    { -- Middle
      { -- Title
        align  = "center",
        widget = awful.titlebar.widget.titlewidget(c)
      },
      buttons = buttons,
      layout  = wibox.layout.flex.horizontal
    },
    { -- Right
      awful.titlebar.widget.floatingbutton (c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton   (c),
      awful.titlebar.widget.ontopbutton  (c),
      awful.titlebar.widget.closebutton  (c),
      layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal
  }
end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--   if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
--     and awful.client.focus.filter(c) then
--     client.focus = c
--   end
-- end)

-- Callback for exitting awesome
-- awesome.connect_signal("exit", function(restarting) end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
--{{{ Daemons and programs startup
-- awful.spawn("gnome-session")
awful.spawn("run-once compton")
awful.spawn("fcitx")
-- awful.spawn("run-once xss-lock -- i3lock-fancy -f /usr/share/fonts/TTF/AURORABC.TTF")
-- awful.spawn("run-once light-locker")
-- awful.spawn("run-once redshift-gtk")
awful.spawn("run-once volumeicon")
-- awful.spawn("blueman-applet")
awful.util.spawn("run-once xss-lock -- i3lock-fancy")
-- awful.util.spawn("run-once i3lock-fancy -- scrot")
awful.spawn("run-once nm-applet")
-- awful.spawn("run-once connman-gtk")
-- awful.util.spawn("ibus-daemon -xrd")
awful.spawn("run-once pcmanfm -d")
awful.spawn("libinput-gestures-setup start")
-- awful.spawn("skypeforlinux")
-- awful.util.spawn("telegram-desktop")
-- awful.util.spawn("skypeforlinux")
-- awful.spawn("geary")
-- awful.util.spawn_with_shell("run-once ~/.config/i3/gmail.sh")
-- awful.spawn("xcompmgr")
--}}}
