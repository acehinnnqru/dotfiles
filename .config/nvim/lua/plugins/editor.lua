return {
	-- telescope
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find file in project" },
			{
				"<leader>fa",
				"<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>",
				desc = "Find file in all files",
			},
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Find text in project" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find text in buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
			{ "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
			{ "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Find project" },
		},
		opts = {
			extensions = {},
			defaults = {
				file_ignore_patterns = { "node_modules", "venv", ".git" },
			},
			pickers = {
				find_files = {
					hidden = true,
				},
				live_grep = {
					additional_args = function(opts)
						return { "--hidden" }
					end,
				},
			},
		},
	},

	-- git blame
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		opts = {
			current_line_blame = true,
			current_line_blame_opts = {
				delay = 100,
			},
			on_attach = function(buffer)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end

                -- stylua: ignore start
                map("n", "]h", gs.next_hunk, "Next Hunk")
                map("n", "[h", gs.prev_hunk, "Prev Hunk")
                map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
                map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
                map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
                map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
                map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
                map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
                map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
                map("n", "<leader>ghd", gs.diffthis, "Diff This")
                map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
			end,
		},
	},
}
