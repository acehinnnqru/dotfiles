return {
	{ "simrat39/rust-tools.nvim", lazy = true },

	-- modified treesitter config
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "rust" })
		end,
	},

	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			table.insert(opts.ensure_installed, "rust-analyzer")
			return opts
		end,
	},

	-- correctly setup lspconfig
	{
		"neovim/nvim-lspconfig",
		opts = {
			-- make sure mason installs the server
			servers = {
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
							},
							checkOnSave = {
								allFeatures = true,
								command = "clippy",
								extraArgs = { "--no-deps" },
							},
							procMacro = {
								ignored = {
									["async-trait"] = { "async_trait" },
									["napi-derive"] = { "napi" },
									["async-recursion"] = { "async_recursion" },
								},
							},
						},
					},
				},
			},
			setup = {
				rust_analyzer = function(_, opts)
					require("plugins.lsp.apis").on_attach(function(client, buffer)
						if client.name == "rust_analyzer" then
							local rt = require("rust-tools")

							local rust_opts = {
								server = vim.tbl_deep_extend("force", {}, opts, opts.server or {}),
								tools = { -- rust-tools options
									-- options same as lsp hover / vim.lsp.util.open_floating_preview()
									hover_actions = {
										-- whether the hover action window gets automatically focused
										auto_focus = true,
									},
								},
							}
							rt.setup(rust_opts)
                            -- stylua: ignore start
							vim.keymap.set( "n", "K", rt.hover_actions.hover_actions, { desc = "Hover Action", buffer = buffer })
							vim.keymap.set( "n", "<leader>cem", rt.expand_macro.expand_macro, { desc = "Expand Macro", buffer = buffer })
							vim.keymap.set( "n", "<leader>cpm", rt.parent_module.parent_module, { desc = "Parent Module", buffer = buffer })
							vim.keymap.set( "n", "<leader>cmd", "RustMoveItemDown", { desc = "Move Item Down", buffer = buffer })
							vim.keymap.set( "n", "<leader>cmu", "RustMoveItemUp", { desc = "Move Item Up", buffer = buffer })
							vim.keymap.set( "n", "<leader>cjl", rt.join_lines.join_lines, { desc = "Join Lines", buffer = buffer })
							vim.keymap.set( "n", "<leader>che", rt.inlay_hints.enable, { desc = "Inlay Hints Enable", buffer = buffer })
							vim.keymap.set( "n", "<leader>chd", rt.inlay_hints.disable, { desc = "Inlay Hints Disable", buffer = buffer })
							-- stylua: ignore end
						end
					end)
					require("lspconfig").rust_analyzer.setup(opts)
					return true
				end,
			},
		},
	},
}
