return {
	-- better diagnostics list and others
	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		opts = { use_diagnostic_signs = true },
		keys = {
			{ "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
		},
	},

	-- todo comments
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" },
		event = "BufReadPost",
		config = true,
        -- stylua: ignore
        keys = {
          { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
          { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
          { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo Trouble" },
          { "<leader>xtt", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo Trouble" },
          { "<leader>xT", "<cmd>TodoTelescope<cr>", desc = "Todo Telescope" },
        },
	},

	-- snippets
	{
		"L3MON4D3/LuaSnip",
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
        -- stylua: ignore
        keys = {
            {
                "<tab>",
                function()
                    return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
                end,
                expr = true, remap = true, silent = true, mode = "i",
            },
            { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
            { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
        },
	},

	-- auto completion
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
			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end
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

			local luasnip = require("luasnip")
			return {
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					---@diagnostic disable-next-line: missing-parameter
					-- ["<Tab>"] = cmp.mapping.complete(),
					["<Tab>"] = cmp.mapping(function(fallback)
						-- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
						if cmp.visible() then
							local entry = cmp.get_selected_entry()
							if not entry then
								cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
							else
								cmp.confirm()
							end
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
                        else
                            fallback()
						end
					end, { "i", "s", "c" }),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "lsp_signature" },
					{ name = "luasnip" },
				}, {
					{ name = "nvim_lsp_signature_help" },
				}, {

					{ name = "buffer" },
					{ name = "path" },
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
						})[entry.source.name]
						return item
					end,
				},
			}
		end,
	},

	-- comment
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	{
		"echasnovski/mini.comment",
		event = "VeryLazy",
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

	-- pairs
	{
		"windwp/nvim-autopairs",
		event = "VeryLazy",
		config = function(_, opts)
			require("nvim-autopairs").setup(opts)
		end,
	},

	-- surround
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		config = function(_, opts)
			require("nvim-surround").setup(opts)
		end,
	},

	--fold
	{
		"kevinhwang91/nvim-ufo",
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

	-- quick fix
	{
		"kevinhwang91/nvim-bqf",
		ft = { "qf" },
	},
}
