hl.monitor({
    output = "eDP-1",
    mode = "1920x1080@144",
    position = "0x0",
    scale = "1"
})

hl.monitor({
    output = "",
    mode = "highres",
    position = "auto",
    scale = "1"
})

hl.env("XCURSOR_SIZE", "24")
hl.env("SSH_AUTH_SOCK", "/run/user/1000/gcr/ssh")

hl.on("hyprland.start", function()
	hl.exec_cmd("systemctl --user start polkit-gnome-authentication-agent-1")
	hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")
    hl.exec_cmd("foot --server")
    hl.exec_cmd("qs")
    hl.exec_cmd("mako --default-timeout 2000 --ignore-timeout 1")
	hl.exec_cmd("sleep 2 && nm-applet")
	hl.exec_cmd("sleep 1.5 && blueman-applet")
	hl.exec_cmd("sleep 1 && rog-control-center")
	hl.exec_cmd("uwsm finalize")
end)

hl.window_rule({ name = "waydroid-fs", match = { class = "Waydroid" }, fullscreen = true })

hl.config({
	animations = { enabled = false },
	general = {
		allow_tearing = true,
		border_size = 2,
		gaps_in = 5,
		gaps_out = 10,
		resize_on_border = true,
		col = {
			inactive_border = "0xff444444",
			active_border = {
				angle = 45,
				colors = {
          			"0xffef7e7e", "0xffe57474", "0xfff4d67a", "0xffe5c76b",
          			"0xff96d988", "0xff8ccf7e", "0xff67cbe7", "0xff6cbfbf",
					"0xff71baf2", "0xffc47fd5",
				},
			},
		},
	},

	decoration = {
		rounding = 0,
		blur = { enabled = false },
		shadow = { enabled = false },
	},

	input = {
		follow_mouse = 1,
		kb_layout = "ro",
		sensitivity = 0,
		touchpad = {
			clickfinger_behavior = true,
			disable_while_typing = true,
			natural_scroll = false,
			tap_to_click = true,
		},
	},

	ecosystem = { no_donation_nag = true, no_update_news = true },
	cursor = { no_hardware_cursors = false },
	render = { direct_scanout = true },
	xwayland = { force_zero_scaling = true },
	dwindle = { preserve_split = true },

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		swallow_regex = "foot",
		middle_click_paste = false,
		disable_watchdog_warning = 1,
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
	},
})
