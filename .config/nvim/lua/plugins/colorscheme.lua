return {
	{
		"projekt0n/github-nvim-theme",
		config = function()
			require("github-theme").setup({
				theme_style = "dark",
				msg_area_style = "italic",
				comment_style = "italic",
				keyword_style = "italic",
				function_style = "italic",
				variable_style = "italic",
				dark_sidebar = false,
				transparent = true,
			})
		end,
	},
}
