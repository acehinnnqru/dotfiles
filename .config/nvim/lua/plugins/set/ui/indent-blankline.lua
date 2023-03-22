return {
	"lukas-reineke/indent-blankline.nvim",
	event = "VeryLazy",
	opts = {
		filetype_exclude = { "help", "alpha", "dashboard", "lazy" },
		show_trailing_blankline_indent = false,
		show_end_of_line = false,
		space_char_blankline = " ",
	},
}
