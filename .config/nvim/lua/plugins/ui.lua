return {
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")
			local logo = {
				[[███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
				[[████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
				[[██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
				[[██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
				[[██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
				[[╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
			}
			dashboard.section.header.val = logo
			dashboard.section.buttons.val = {
				dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
				dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
				dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
				dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
				dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
			}

			local function footer()
				return "acehinnnqru"
			end

			dashboard.section.footer.val = footer()

			dashboard.section.footer.opts.hl = "Comment"
			dashboard.section.header.opts.hl = "String"
			dashboard.section.buttons.opts.hl = "Keyword"

			dashboard.opts.opts.noautocmd = true

			alpha.setup(dashboard.opts)
		end,
	},
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		opts = {
			options = {
				diagnostics = "nvim_lsp",
				show_tab_indicators = false,
				show_close_icon = false,
				separator_style = {
					"",
					"",
				},
			},
		},
	},
	{
		"nmac427/guess-indent.nvim",
		event = "VeryLazy",
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "VeryLazy",
		opts = {
			filetype_exclude = { "help", "alpha", "dashboard", "lazy" },
			show_trailing_blankline_indent = false,
			show_end_of_line = false,
			space_char_blankline = " ",
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",

		opts = {
			options = {
				disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
			},
		},
	},
	{
		"xiyaowong/nvim-transparent",
		event = "VimEnter",
		config = function()
			require("transparent").setup({})
			vim.g.transparent_enabled = true
		end,
	},
	{
		"kyazdani42/nvim-web-devicons",
		opts = {
			default = true,
		},
	},
}
