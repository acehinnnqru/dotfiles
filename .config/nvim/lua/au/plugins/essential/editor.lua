return {
    -- auto pairs
    {
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
    },

    -- surround
    {
		"kylechui/nvim-surround",
		event = "InsertEnter",
		config = true,
    },

    -- comment plugin
    {
		"echasnovski/mini.comment",
		keys = { "gc", "gcc" },
		config = true,
    },

    -- indent
    -- support context, line start
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
}
