local project_lib = require("libs.project")
local telescope = function(builtin, opts)
	local params = { builtin = builtin, opts = opts }
	return function()
		builtin = params.builtin
		opts = params.opts
		opts = vim.tbl_deep_extend("force", { cwd = project_lib.get_root() }, opts or {})
		if builtin == "files" then
			if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
				opts.show_untracked = true
				builtin = "git_files"
			else
				builtin = "find_files"
			end
		elseif builtin == "man_pages" then
			opts = {
				prompt_title = "   Find man pages ",
				sections = { "ALL" },
				man_cmd = { "apropos", ".*" },
			}
		end
		require("telescope.builtin")[builtin](opts)
	end
end

return {
	{
		"rmagatti/auto-session",
		init = function()
			vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
		end,
		config = function()
			require("auto-session").setup({
				log_level = "error",
				auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
				pre_save_cmds = {
					function()
						require("neo-tree.sources.manager").close_all()
						require("dapui").close()
						vim.cmd("cclose")
						vim.notify("closed all")
					end,
				},
			})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
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

				map("n", "]h", gs.next_hunk, "Next Hunk")
				map("n", "[h", gs.prev_hunk, "Prev Hunk")
				map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
				map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
				map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
				map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
				map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
				map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
				map("n", "<leader>ghb", function()
					gs.blame_line({ full = true })
				end, "Blame Line")
				map("n", "<leader>ghd", gs.diffthis, "Diff This")
				map("n", "<leader>ghD", function()
					gs.diffthis("~")
				end, "Diff This ~")
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
			end,
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		cmd = "Neotree",
		keys = {
			{
				"<leader>fe",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = require("libs.project").get_root() })
				end,
				desc = "Explorer NeoTree (root dir)",
			},
			{
				"<leader>fE",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
				end,
				desc = "Explorer NeoTree (cwd)",
			},
			{ "<leader>e", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
			{ "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
		},
		init = function()
			vim.g.neo_tree_remove_legacy_commands = 1
			if vim.fn.argc() == 1 then
				local stat = vim.loop.fs_stat(vim.fn.argv(0))
				if stat and stat.type == "directory" then
					require("neo-tree")
				end
			end
		end,
		opts = {
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
				},
				bind_to_cwd = false,
				follow_current_file = true,
			},
			window = {
				mappings = {
					["<space>"] = "none",
				},
			},
		},
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		lazy = true,
		dependencies = { "nvim-telescope/telescope.nvim" },
		build = "make",
	},
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		version = false,
		keys = {
			{ "<leader>/", telescope("live_grep"), desc = "Find in Files (Grep)" },
			{ "<leader><space>", telescope("files"), desc = "Find Files (root dir)" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>ff", telescope("files"), desc = "Find Files (root dir)" },
			{ "<leader>fF", telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Find text in project" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find text in buffers" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
			{ "<leader>ha", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
			{ "<leader>hc", "<cmd>Telescope commands<cr>", desc = "Commands" },
			{ "<leader>hf", "<cmd>Telescope filetypes<cr>", desc = "File Types" },
			{ "<leader>hh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
			{ "<leader>hk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
			{ "<leader>hm", telescope("man_pages"), desc = "Man Pages" },
			{ "<leader>ho", "<cmd>Telescope vim_options<cr>", desc = "Options" },
			{ "<leader>hs", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
			{ "<leader>ht", "<cmd>Telescope builtin<cr>", desc = "Telescope Builtin" },
			{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
			{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
			{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
			{ "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
			{ "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
			{
				"<leader>ss",
				telescope("lsp_document_symbols", {
					symbols = {
						"Class",
						"Function",
						"Method",
						"Constructor",
						"Interface",
						"Module",
						"Struct",
						"Trait",
						"Field",
						"Property",
					},
				}),
				desc = "Goto Symbol",
			},
		},
		opts = {
			extensions = {
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					-- the default case_mode is "smart_case"
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				},
			},
			defaults = {},
			pickers = {
				find_files = {
					hidden = true,
				},
				live_grep = {
					additional_args = function(_)
						return { "--hidden" }
					end,
				},
			},
			man_cmd = { "apropos", ".*" },
		},
		config = function(_, opts)
			require("telescope").setup(opts)
			require("telescope").load_extension("fzf")
		end,
	},
	{
		"folke/which-key.nvim",
		lazy = true,
		keys = { "<leader>" },
		opts = {
			plugins = { spelling = true },
			key_labels = { ["<leader>"] = "SPC" },
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			wk.register({
				mode = { "n", "v" },
				["g"] = { name = "+goto" },
				["]"] = { name = "+next" },
				["["] = { name = "+prev" },
				["<leader>b"] = { name = "+buffer" },
				["<leader>c"] = { name = "+code" },
				["<leader>f"] = { name = "+file" },
				["<leader>g"] = { name = "+git" },
				["<leader>gh"] = { name = "+hunk" },
				["<leader>h"] = { name = "+help" },
				["<leader>j"] = { name = "+jump" },
				["<leader>o"] = { name = "+open" },
				["<leader>q"] = { name = "+quit/session" },
				["<leader>r"] = { name = "+restart/reload" },
				["<leader>s"] = { name = "+search" },
				["<leader>t"] = { name = "+toggle" },
				["<leader>x"] = { name = "+diagnostics/quickfix" },
				["<leader>w"] = { name = "+windows" },
				["<leader>d"] = { name = "+debug" },
				["<leader>dv"] = { name = "+views" },
			})
		end,
	},
}
