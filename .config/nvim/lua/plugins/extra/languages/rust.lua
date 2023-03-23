return {
	-- Extend auto completion
	{
		"hrsh7th/nvim-cmp",
        event = "InsertEnter",
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

	-- modified treesitter config
	{
		"nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "rust", "ron", "toml" })
		end,
	},

	{
		"williamboman/mason.nvim",
        event = "VeryLazy",
		opts = function(_, opts)
			table.insert(opts.ensure_installed, "rust-analyzer")
			table.insert(opts.ensure_installed, "codelldb")
			return opts
		end,
	},

	{
		"neovim/nvim-lspconfig",
        event = "VeryLazy",
		dependencies = { "simrat39/rust-tools.nvim" },
		opts = {
			servers = {
				rust_analyzer = {},
			},
			setup = {
				rust_analyzer = function(_, opts)
					require("plugins.lsp.apis").on_attach(function(client, buffer)
						if client.name == "rust_analyzer" then
							local rt = require("rust-tools")
                            -- stylua: ignore start
                            vim.keymap.set( "n", "K", "<cmd>RustHoverActions<cr>", { desc = "Hover Action", buffer = buffer })
                            vim.keymap.set( "n", "<leader>cem", rt.expand_macro.expand_macro, { desc = "Expand Macro", buffer = buffer })
                            vim.keymap.set( "n", "<leader>cpm", rt.parent_module.parent_module, { desc = "Parent Module", buffer = buffer })
                            vim.keymap.set( "n", "<leader>cmd", "<cmd>RustMoveItemDown<cr>", { desc = "Move Item Down", buffer = buffer })
                            vim.keymap.set( "n", "<leader>cmu", "<cmd>RustMoveItemUp<cr>", { desc = "Move Item Up", buffer = buffer })
                            vim.keymap.set( "n", "<leader>cjl", rt.join_lines.join_lines, { desc = "Join Lines", buffer = buffer })
                            vim.keymap.set("n", "<leader>dr", "<cmd>RustDebuggables<cr>", { buffer = buffer, desc = "Run Debuggables (Rust)" })
							-- stylua: ignore end
						end
					end)
					local mason_registry = require("mason-registry")
					-- rust tools configuration for debugging support
					local codelldb = mason_registry.get_package("codelldb")
					local extension_path = codelldb:get_install_path() .. "/extension/"
					local codelldb_path = extension_path .. "adapter/codelldb"
					local liblldb_path = vim.fn.has("mac") == 1 and extension_path .. "lldb/lib/liblldb.dylib"
						or extension_path .. "lldb/lib/liblldb.so"

					local rust_opts = {
						dap = {
							adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
						},
						tools = {
							on_initialized = function()
								vim.cmd([[
									augroup RustLSP
										autocmd CursorHold                      *.rs silent! lua vim.lsp.buf.document_highlight()
										autocmd CursorMoved,InsertEnter         *.rs silent! lua vim.lsp.buf.clear_references()
										autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
									augroup END
								]])
							end,
							inlay_hint = {
								auto = false,
							},
						},
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
					require("rust-tools").setup(rt_opts)
					return true
				end,
			},
		},
	},
}
