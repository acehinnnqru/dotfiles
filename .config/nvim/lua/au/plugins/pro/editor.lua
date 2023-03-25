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

    -- better fold
    {
		"kevinhwang91/nvim-ufo",
		event = "VeryLazy",
		dependencies = { "kevinhwang91/promise-async" },
		opts = {
			open_fold_hl_timeout = 0,
			provider_selector = function(_, _, _)
                return { "indent" }
			end,
		},
		config = function(_, opts)
			vim.o.foldcolumn = "0"

			-- using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			require("ufo").setup(opts)
		end,
	},
}
