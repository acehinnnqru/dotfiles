return {
	-- modified treesitter config
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "rust" })
		end,
	},

	-- correctly setup lspconfig
	{
		"neovim/nvim-lspconfig",
		dependencies = { "simrat39/rust-tools.nvim" },
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

                            -- stylua: ignore start
							vim.keymap.set( "n", "K", rt.hover_actions.hover_actions, { desc = "Hover Action", buffer = buffer })
							vim.keymap.set( "n", "<leader>em", rt.expand_macro.expand_macro, { desc = "Expand Macro", buffer = buffer })
							vim.keymap.set( "n", "<leader>pm", rt.parent_module.parent_module, { desc = "Parent Module", buffer = buffer })
							vim.keymap.set( "n", "<leader>run", rt.runnables.runnables, { desc = "Runnables", buffer = buffer })
							vim.keymap.set( "n", "<leader>md", "RustMoveItemDown", { desc = "Move Item Down", buffer = buffer })
							vim.keymap.set( "n", "<leader>mu", "RustMoveItemUp", { desc = "Move Item Up", buffer = buffer })
							vim.keymap.set( "n", "<leader>jl", rt.join_lines.join_lines, { desc = "Join Lines", buffer = buffer })
							vim.keymap.set( "n", "<leader>ihe", rt.inlay_hints.enable, { desc = "Inlay Hints Enable", buffer = buffer })
							vim.keymap.set( "n", "<leader>ihd", rt.inlay_hints.disable, { desc = "Inlay Hints Disable", buffer = buffer })
							-- stylua: ignore end
						end
					end)
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
					require("rust-tools").setup(rust_opts)
					return true
				end,
			},
		},
	},
}
