return {
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
		--
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
				["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
}
