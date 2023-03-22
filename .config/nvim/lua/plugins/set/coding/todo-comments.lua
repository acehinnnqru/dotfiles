return {
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
}
