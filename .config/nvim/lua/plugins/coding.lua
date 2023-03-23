local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
	{
		"zbirenbaum/copilot-cmp",
		event = "InsertEnter",
		dependencies = {
			"zbirenbaum/copilot.lua",
		},
		config = function(_, opts)
			require("copilot_cmp").setup(opts)
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		cmd = "Copilot",
		opts = {
			panel = {
				enabled = false,
				auto_refresh = true,
			},
			suggestion = {
				enabled = false,
				auto_trigger = false,
			},
		},
		config = function(_, opts)
			require("copilot").setup(opts)
		end,
	},
	{
		"phaazon/hop.nvim",
		branch = "v2",
		config = function(_, opts)
			require("hop").setup(opts)
		end,
		keys = {
			{ "<leader>jl", "<cmd>HopLine<cr>", desc = "Jump to Line" },
			{ "<leader>jw", "<cmd>HopWord<cr>", desc = "Jump to Word" },
			{ "<leader>jv", "<cmd>HopVertical<cr>", desc = "Jump to line vertically" },
			{ "<leader>jp", "<cmd>HopPattern<cr>", desc = "Jump to Pattern" },
		},
	},
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		config = true,
	},
	{
		"L3MON4D3/LuaSnip",
		event = "InsertEnter",
		dependencies = {
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
	},
	{
		"echasnovski/mini.comment",
		keys = { "gc", "gcc" },
		opts = {
			hooks = {
				pre = function()
					require("ts_context_commentstring.internal").update_commentstring({})
				end,
			},
		},
		config = function(_, opts)
			require("mini.comment").setup(opts)
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function(_, opts)
			require("nvim-autopairs").setup(opts)
		end,
	},
	{
		"kevinhwang91/nvim-bqf",
		dependencies = { "junegunn/fzf" },
		ft = { "qf" },
	},

	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"f3fora/cmp-spell",
			"hrsh7th/cmp-cmdline",
			"petertriho/cmp-git",
		},
		opts = function()
			local cmp = require("cmp")

			-- autopairs setup
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			-- git commit completion
			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
				}, {
					{ name = "buffer" },
				}),
			})

			-- command line completion
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})

			return {
				completion = {},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
					["<Tab>"] = cmp.mapping(function(fallback)
						local luasnip = require("luasnip")
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						local luasnip = require("luasnip")
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "copilot" },
					{ name = "nvim_lsp" },
					{ name = "lsp_signature" },
					{ name = "luasnip" },
				}, {
					{ name = "nvim_lsp_signature_help" },
				}, {
					{ name = "path" },
					{ name = "buffer" },
				}),
				experimental = {
					ghost_text = {
						hl_group = "LspCodeLens",
					},
				},
				formatting = {
					format = function(entry, item)
						item.kind = string.format("(%s)", item.kind)
						item.menu = ({
							nvim_lsp = "[LSP]",
							spell = "[Spellings]",
							buffer = "[Buffer]",
							luasnip = "[Snip]",
							path = "[Path]",
							nvim_lsp_signature_help = "[Signature]",
							lsp_signature = "[Signature]",
							cmdline = "[Vim Command]",
							copilit = "[Copilot]",
						})[entry.source.name]
						return item
					end,
				},
			}
		end,
	},
	{
		"kylechui/nvim-surround",
		event = "InsertEnter",
		config = function(_, opts)
			require("nvim-surround").setup(opts)
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		-- event = "BufReadPost",
	},
	{
		"kevinhwang91/nvim-ufo",
		event = "VeryLazy",
		dependencies = { "kevinhwang91/promise-async" },
		opts = {
			open_fold_hl_timeout = 0,
			provider_selector = function(_, _, _)
				return { "treesitter", "indent" }
			end,
		},
		config = function(_, opts)
			vim.o.foldcolumn = "0"
			-- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			require("ufo").setup(opts)
		end,
	},
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" },
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next todo comment",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Previous todo comment",
			},
			{ "<leader>xt", "<cmd>TodoQuickFix<cr>", desc = "Todo Trouble" },
			{ "<leader>xT", "<cmd>TodoTelescope<cr>", desc = "Todo Telescope" },
		},
		config = true,
	},
}
