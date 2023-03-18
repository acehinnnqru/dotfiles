return {
	-- Extend auto completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{
				"Saecki/crates.nvim",
				event = { "BufRead Cargo.toml" },
				config = true,
			},
		},
		---@param opts cmp.ConfigSchema
		opts = function(_, opts)
			local cmp = require("cmp")
			opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
				{ name = "crates", priority = 750 },
			}))
		end,
	},

	{ "simrat39/rust-tools.nvim", lazy = true, ft = { "rs", "rust" } },

	-- modified treesitter config
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "rust", "ron", "toml" })
		end,
	},

	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			table.insert(opts.ensure_installed, "rust-analyzer")
			return opts
		end,
	},

	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				rust_analyzer = {},
			},
		},
		setup = {
			rust_analyzer = function(_, opts)
				require("plugins.lsp.apis").on_attach(function(client, buffer)
					if client.name == "rust_analyzer" then
						local rt = require("rust-tools")
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

				local rt = require("rust-tools")
				local rust_opts = {
					server = {
						settings = {
							["rust-analyzer"] = {
								cargo = {
									allFeatures = true,
									loadOutDirsFromCheck = true,
									runBuildScripts = true,
								},
								checkOnSave = {
									allFeatures = true,
									command = "clippy",
									extraArgs = { "--no-deps" },
								},
								procMacro = {
									enable = true,
									ignored = {
										["async-trait"] = { "async_trait" },
										["napi-derive"] = { "napi" },
										["async-recursion"] = { "async_recursion" },
									},
								},
							},
						},
					},
				}
				local rt_opts = vim.tbl_deep_extend("force", opts, rust_opts)
				rt.setup(rt_opts)
				return true
			end,
		},
	},
}
