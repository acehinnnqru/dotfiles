return {
	-- modified treesitter config
	{
		"nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "lua" })
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
			vim.list_extend(opts.ensure_installed, { "stylua" })
		end,
	},

	{
		"jose-elias-alvarez/null-ls.nvim",
        event = "VeryLazy",
		opts = function(_, opts)
			local nls = require("null-ls")
			table.insert(opts.sources, nls.builtins.formatting.stylua)
		end,
	},

	{
		"jay-babu/mason-nvim-dap.nvim",
        event = "VeryLazy",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "stylua", "jq" })
		end,
	},

	-- correctly setup lspconfig
	{
		"neovim/nvim-lspconfig",
        event = "VeryLazy",
		opts = {
			-- make sure mason installs the server
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							runtime = {
								version = "LuaJIT",
							},
							diagnostics = {
								globals = { "vim" },
							},
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
								checkThirdParty = false,
							},
							telemetry = {
								enable = false,
							},
						},
					},
				},
			},
		},
	},
}
