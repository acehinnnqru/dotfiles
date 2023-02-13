return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "BufReadPost",
		opts = {
			ensure_installed = {
				-- config filetypes
				"markdown",
				"yaml",
				"toml",
				"gitignore",
				"markdown_inline",

				-- script languages
				"bash",
				"vim",
				"sql",

				-- web related
				"javascript",
				"html",
				"css",
				"typescript",
				"vue",
				"tsx",

				-- other
				"comment",
				"regex",
				"help",
			},
			sync_install = false,
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
			},
			context_commentstring = {
				enable = true,
			},
		},

		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
}
