return {
    -- quick jump everywhere
    {
		"phaazon/hop.nvim",
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
        init = function()
			vim.o.foldcolumn = "0"

			-- using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
        end,
		opts = {
			open_fold_hl_timeout = 0,
			provider_selector = function(_, _, _)
                return { "indent" }
			end,
		},
		config =true,
    },

    -- session using for store work status
    {
		"rmagatti/auto-session",
        lazy = false,
		init = function()
			vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
		end,
        opts = {
            log_level = "error",
            auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
            pre_save_cmds = {},
        },
		config = true,
    },

    -- todo comments
    -- keywords: TODO/FIXME/PERF/NOTE/TEST
    -- usage: using `{keyword}: {text}`
    {
		"folke/todo-comments.nvim",
        event = "VeryLazy",
		cmd = { "TodoQuickFix", "TodoTelescope" },
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
	},
}
