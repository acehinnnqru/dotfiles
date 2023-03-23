return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = "VeryLazy",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "go", "gomod" })
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
			vim.list_extend(opts.ensure_installed, { "golangci-lint", "goimports", "gofmt" })
		end,
	},
	{
		"williamboman/mason.nvim",
		event = "VeryLazy",
		opts = function(_, opts)
			table.insert(opts.ensure_installed, "gopls")
			return opts
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = "VeryLazy",
		opts = function(_, opts)
			local nls = require("null-ls")
			table.insert(opts.sources, nls.builtins.code_actions.gomodifytags)
			table.insert(opts.sources, nls.builtins.diagnostics.golangci_lint)
			table.insert(opts.sources, nls.builtins.formatting.goimports)
			table.insert(opts.sources, nls.builtins.formatting.gofmt)
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		event = "VeryLazy",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "delve" })
		end,
	},
	{
		"leoluz/nvim-dap-go",
		lazy = true,
		dependencies = {
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui",
			"jay-babu/mason-nvim-dap.nvim",
		},
		ft = "go",
		config = true,
	},

	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		opts = {
			servers = {
				gopls = {
					settings = {},
				},
			},
			settings = {
				gopls = {
					gofumpt = true,
					codelenses = {
						gc_details = false,
						generate = true,
						regenerate_cgo = true,
						run_govulncheck = true,
						test = true,
						tidy = true,
						upgrade_dependency = true,
						vendor = true,
					},
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
					analyses = {
						fieldalignment = true,
						nilness = true,
						unusedparams = true,
						unusedwrite = true,
						useany = true,
					},
					usePlaceholders = true,
					completeUnimported = true,
					staticcheck = true,
					directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
					semanticTokens = true,
				},
			},
		},
	},
}
