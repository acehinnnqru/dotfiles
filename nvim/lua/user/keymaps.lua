local opts = { noremap = true, silent = true }

local keymap = vim.api.nvim_set_keymap

-- remap leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- buffers navigation
--[[ keymap("n", "<S-l>", ":bnext<CR>", opts) ]]
--[[ keymap("n", "<S-h>", ":bprevious<CR>", opts) ]]
keymap("n", "<leader>bc", ":bdelete<CR>", opts)
keymap("n", "<leader>bd", ":bufdo bd<CR>", opts)

-- telescope plugin keymaps
keymap("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", opts)
keymap("n", "<leader>fa", "<cmd>lua require('telescope.builtin').find_files({hidden=true})<cr>", opts)
keymap("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", opts)
keymap("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", opts)
keymap("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", opts)
keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
keymap("n", "<leader>fs", ":Telescope file_browser<CR>", opts)

-- nvim-tree
keymap("n", "<leader>tf", ":NvimTreeFocus<CR>", opts)
keymap("n", "<leader>tr", ":NvimTreeRefresh<CR>", opts)
keymap("n", "<leader>tt", ":NvimTreeToggle<CR>", opts)
keymap("n", "<leader>tc", ":NvimTreeClose<CR>", opts)

-- disable some keymaps
keymap("n", "<A-CR>", "<Nop>", opts)
