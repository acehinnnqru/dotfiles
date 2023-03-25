return {
    -- quick jump everywhere
    {
		"phaazon/hop.nvim",
        lazy = false,
		branch = "v2",
		config = true,
        keys = {
			{ "<leader>jl", "<cmd>HopLine<cr>", desc = "Jump to Line" },
			{ "<leader>jw", "<cmd>HopWord<cr>", desc = "Jump to Word" },
			{ "<leader>jv", "<cmd>HopVertical<cr>", desc = "Jump to Line vertically" },
			{ "<leader>jp", "<cmd>HopPattern<cr>", desc = "Jump to Pattern" },
		},
	},
}
