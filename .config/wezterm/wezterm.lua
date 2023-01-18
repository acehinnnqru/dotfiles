local wezterm = require("wezterm")
return {
	color_scheme = "Catppuccin Macchiato",
	font = wezterm.font_with_fallback({
		{
			family = "Consolas",
			style = "Italic",
		},
		{
			family = "Hack Nerd Font Mono",
		},
	}),
	font_size = 13.0,

	window_decorations = "RESIZE",

	hide_tab_bar_if_only_one_tab = true,
	window_background_opacity = 0.75,
}
