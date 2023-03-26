--- this module contains some enhanced tools that will boost your workflow.
-- including telescope, tree-sitter and stuff.

-- telescope cmd wrapping
local telescope = function(builtin, opts)
	local params = { builtin = builtin, opts = opts }
	return function()
		builtin = params.builtin
		opts = params.opts
		opts = vim.tbl_deep_extend("force", { cwd = require("au.utils").get_root() }, opts or {})
		if builtin == "files" then
			if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
				opts.show_untracked = true
				builtin = "git_files"
			else
				builtin = "find_files"
			end
        -- fix in Ventura(MacOS 13)
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
    -- telescope native fzf extension
    {
		"nvim-telescope/telescope-fzf-native.nvim",
		lazy = true,
		dependencies = { "nvim-telescope/telescope.nvim" },
		build = "make",
	},
    -- telescope
    {
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		version = false,
		keys = {
            { "<leader>tt", "<cmd>Telescope<cr>", desc = "Open Telescope Window" },
            -- super cmds
			{ "<leader><space>", telescope("files"), desc = "Find Files (root dir)" },
			{ "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Find text in project" },
			{ "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
			{ "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },

            -- search
			{ "<leader>sf", telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
			{ "<leader>sr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
			{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Grep in Buffer" },
			{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
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
            { "<leader>sq", "<cmd>Telescope quickfixhistory", desc = "quickfix history" },

            -- git
            { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
            { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" },
            { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },

            -- help
			{ "<leader>ha", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
			{ "<leader>hc", "<cmd>Telescope commands<cr>", desc = "Commands" },
			{ "<leader>hf", "<cmd>Telescope filetypes<cr>", desc = "File Types" },
			{ "<leader>hh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
			{ "<leader>hk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
			{ "<leader>hm", telescope("man_pages"), desc = "Man Pages" },
			{ "<leader>ho", "<cmd>Telescope vim_options<cr>", desc = "Options" },
			{ "<leader>ht", "<cmd>Telescope builtin<cr>", desc = "Telescope Builtin" },
		},
		opts = {
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
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
}
