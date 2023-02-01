return {
	{ "ray-x/go.nvim", lazy = true },

	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "go", "gomod" })
		end,
	},

	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			table.insert(opts.ensure_installed, "gopls")
			return opts
		end,
	},

	-- correctly setup lspconfig
	{
		"neovim/nvim-lspconfig",
		opts = {
			-- make sure mason installs the server
			servers = {
				gopls = {
					settings = {},
				},
			},
			setup = {
				gopls = function(_, opts)
					require("plugins.lsp.apis").on_attach(function(client, buffer)
						if client.name == "gopls" then
							local format = function()
								require("go.format").goimport()
							end
							vim.keymap.set(
								"n",
								"<leader>cf",
								format,
								{ desc = "Format Document", buffer = buffer }
							)
							vim.keymap.set(
								"v",
								"<leader>cf",
								format,
								{ desc = "Format Range", buffer = buffer }
							)
							require("go").setup()
						end
					end)
					require("lspconfig").gopls.setup(opts)
				end,
			},
		},
	},
}
