local wezterm = require("wezterm")
local configs = {}

-- appearance options
-- color_scheme
configs.color_scheme = "Catppuccin Macchiato"
-- window padding
configs.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}

-- opacity
configs.window_background_opacity = 0.80

-- tab bar
configs.window_decorations = "RESIZE"
configs.hide_tab_bar_if_only_one_tab = true

-- font options
configs.font = wezterm.font_with_fallback({
	{
		family = "Consolas",
	},

	{
		family = "Hack Nerd Font Mono",
	},

	{
		family = "PingFang SC",
	},
})
configs.font_size = 15.5

return configs
