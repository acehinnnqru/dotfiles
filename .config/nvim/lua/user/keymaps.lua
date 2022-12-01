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

-- hop keymaps
keymap('', '<leader>sp', ':HopPattern<cr>', opts)
keymap('', '<leader>sw', ':HopWord<cr>', opts)
keymap('', '<leader>sc', ':HopChar2<cr>', opts)
keymap('', '<leader>sl', ':HopLine<cr>', opts)

-- disable some keymaps
keymap("n", "<A-CR>", "<Nop>", opts)
