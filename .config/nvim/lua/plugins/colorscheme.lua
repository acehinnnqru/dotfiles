return {
	{
		"projekt0n/github-nvim-theme",
		lazy = false,
		priority = 1000,
		config = function()
			require("github-theme").setup({
    theme_style = 'dark',
    comment_style = "italic",
    keyword_style = "italic",
    function_style = "italic",
    variable_style = "italic",
    dark_sidebar = false,
    transparent = true,
})
end,
	}
}
