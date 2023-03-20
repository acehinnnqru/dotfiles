return {
	"phaazon/hop.nvim",
	branch = "v2",
	event = "VeryLazy",
	config = function(_, opts)
		require("hop").setup(opts)
	end,
	keys = {
		{ "<leader>jl", "<cmd>HopLine<cr>", desc = "Jump to Line" },
		{ "<leader>jw", "<cmd>HopWord<cr>", desc = "Jump to Word" },
		{ "<leader>jv", "<cmd>HopVertical<cr>", desc = "Jump to line vertically" },
		{ "<leader>jp", "<cmd>HopPattern<cr>", desc = "Jump to Pattern" },
	},
}
