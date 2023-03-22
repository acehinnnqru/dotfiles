return {
	{
		"nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "python" })
		end,
	},
	{
		"jay-babu/mason-null-ls.nvim",
        event = "VeryLazy",
		dependencies = {
			"jose-elias-alvarez/null-ls.nvim",
			"williamboman/mason.nvim",
		},
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "flake8", "mypy", "autopep8", "isort" })
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
        event = "VeryLazy",
		opts = function(_, opts)
			local nls = require("null-ls")
			table.insert(opts.sources, nls.builtins.diagnostics.flake8)
			table.insert(opts.sources, nls.builtins.diagnostics.mypy)
			table.insert(opts.sources, nls.builtins.formatting.autopep8)
			table.insert(opts.sources, nls.builtins.formatting.isort)
		end,
	},
	{
		"neovim/nvim-lspconfig",
        event = "VeryLazy",
		opts = {
			servers = {
				pyright = {
					settings = {
						python = {
							analysis = {
								autoSearchPaths = true,
								diagnosticMode = "workspace",
								useLibraryCodeForTypes = true,
							},
						},
					},
				},
			},
		},
	},
}
