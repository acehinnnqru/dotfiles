return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",

	opts = {
		options = {
			disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
			section_separators = { left = "", right = "" },
			component_separators = { left = "", right = "" },
		},
	},
}
