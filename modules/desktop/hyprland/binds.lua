local bind = hl.bind
local dsp = hl.dsp
local window = dsp.window
local function uwsm(x) return dsp.exec_cmd("uwsm app -- " .. x) end

local SINK = "@DEFAULT_AUDIO_SINK@"
local fuck = "systemd-run --user --quiet --no-block --collect "

bind("SUPER + SHIFT + Q", dsp.exit())
bind("SUPER + Q", window.close())
bind("SUPER + F", window.fullscreen())
bind("SUPER + T", window.float({ action = "toggle" }))

bind("SUPER + Return", uwsm("footclient"))
bind("SUPER + Space", uwsm("rofi -show drun"))
bind("SUPER + E", uwsm("nautilus"))
bind("SUPER + W", uwsm("chromium"))
bind("Print", uwsm("hyprshot -o ~/Pictures/Screenshots -m region"))
bind("ALT + E", dsp.exec_cmd("qs ipc call wp walk 1"))
bind("ALT + Q", dsp.exec_cmd("qs ipc call wp walk -1"))

for i = 1, 10 do
	local key = i % 10
	bind("SUPER + " .. key, dsp.focus({ workspace = i }))
	bind("SUPER + SHIFT + " .. key, window.move({ workspace = i }))
end

bind("XF86AudioRaiseVolume", uwsm("wpctl set-volume -l 1.0 " .. SINK .. " 5%+"), { locked = true, repeating = true })
bind("XF86AudioLowerVolume", uwsm("wpctl set-volume -l 1.0 " .. SINK .. " 5%-"), { locked = true, repeating = true })
bind("XF86AudioMute", uwsm("wpctl set-mute " .. SINK .. " toggle"), { locked = true })
bind("XF86MonBrightnessUp", uwsm("brightnessctl set 5%+"), { locked = true, repeating = true })
bind("XF86MonBrightnessDown", uwsm("brightnessctl set 5%-"), { locked = true, repeating = true })

bind("SUPER + mouse:272", window.drag(), { mouse = true })
bind("SUPER + mouse:273", window.resize(), { mouse = true })
bind("SUPER + mouse_up", dsp.focus({ workspace = "e+1" }))
bind("SUPER + mouse_down", dsp.focus({ workspace = "e-1" }))
