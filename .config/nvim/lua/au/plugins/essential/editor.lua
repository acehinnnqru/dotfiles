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
}
