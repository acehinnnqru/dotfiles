return {
	{
		"nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "javascript", "html", "css", "typescript" })
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
			vim.list_extend(opts.ensure_installed, { "eslint_d", "prettier" })
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
		opts = function(_, opts)
			table.insert(opts.ensure_installed, "tsserver")
			table.insert(opts.ensure_installed, "html")
			table.insert(opts.ensure_installed, "cssls")
			return opts
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
        event = "VeryLazy",
		opts = function(_, opts)
			local nls = require("null-ls")
			table.insert(opts.sources, nls.builtins.formatting.prettier)
		end,
	},
	{
		"neovim/nvim-lspconfig",
        event = "VeryLazy",
		opts = {
			servers = {
				tsserver = {
					init_options = {
						providePrefixAndSuffixTextForRename = true,
						allowRenameOfImportPath = true,
						maxTsServerMemory = 12288,
					},
					preferences = {
						importModuleSpecifierPreference = "relative",
					},
				},
			},
			setup = {
				tsserver = function(_, opts)
					require("plugins.lsp.apis").on_attach(function(client, buffer)
						if client.name == "tsserver" then
							client.server_capabilities.documentFormattingProvider = false
							client.server_capabilities.documentRangeFormattingProvider = false
						end
					end)

					vim.api.nvim_create_autocmd("FileType", {
						pattern = "html,typescript,typescriptreact,javascript,javascriptreact,css,less",
						callback = function()
							vim.opt_local.shiftwidth = 2
							vim.opt_local.tabstop = 2
						end,
					})

					require("lspconfig").tsserver.setup(opts)
				end,
			},
		},
	},
}
