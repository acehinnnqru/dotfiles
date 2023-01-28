-- this will return a function that calls telescope.
-- cwd will defautlt to lazyvim.util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
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
		end
		require("telescope.builtin")[builtin](opts)
	end
end

return {
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
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
		{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
		{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
		{ "<leader>ha", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
		{ "<leader>hc", "<cmd>Telescope commands<cr>", desc = "Commands" },
		{ "<leader>hf", "<cmd>Telescope filetypes<cr>", desc = "File Types" },
		{ "<leader>hh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
		{ "<leader>hk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
		{ "<leader>hm", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
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
		defaults = {
			file_ignore_patterns = { "node_modules", "venv", ".git" },
		},
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
	},
	config = function(_, opts)
		require("telescope").setup(opts)
		require("telescope").load_extension("fzf")
	end,
}
