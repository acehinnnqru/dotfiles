return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		config = function()
			require("catppuccin").setup({
				transparent = true,
				flavour = "macchiato",
				styles = {
					comments = { "italic" },
					conditionals = { "italic" },
					loops = {},
					functions = { "italic" },
					keywords = { "italic" },
					strings = {},
					variables = {},
					numbers = {},
					booleans = { "italic" },
					properties = {},
					types = {},
					operators = {},
				},
			})

			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
