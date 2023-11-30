local wezterm = require("wezterm")
local configs = {}

-- appearance options
-- color scheme
configs.color_scheme = "nordfox"
-- window padding
configs.window_padding = {
	left = "1cell",
	right = "1cell",
	top = "0.5cell",
	bottom = "0.5cell",
}

-- opacity
configs.window_background_opacity = 0.95

-- tab bar
configs.window_decorations = "RESIZE"
configs.hide_tab_bar_if_only_one_tab = true

-- font options
configs.font = wezterm.font_with_fallback({
	{
		family = "Monaspace Neon",
	},
	{
		family = "Iosevka Term",
	},

	{
		family = "Hack Nerd Font Mono",
	},

	{
		family = "PingFang SC",
	},
})
configs.font_size = 14.5

configs.keys = {
	{
		key = "t",
		mods = "CMD",
		action = wezterm.action.ActivateLastTab,
	},
	{
		key = "Enter",
		mods = "ALT",
		action = wezterm.action.DisableDefaultAssignment,
	},
}

configs.max_fps = 120

return configs
