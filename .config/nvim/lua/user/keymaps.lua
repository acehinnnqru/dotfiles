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
keymap("n", "<leader>bd", ":bdelete<CR>", opts)
keymap("n", "<leader>bp", ":bprevious<CR>", opts)
keymap("n", "<leader>bn", ":bnext<CR>", opts)

-- telescope plugin keymaps
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fa", ":Telescope find_files find_command=rg,--ignore,--hidden,--files<CR>", opts)
keymap("n", "<leader>fg", ":Telescope  live_grep<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)
keymap("n", "<leader>fh", ":Telescope help_tags<CR>", opts)
keymap("n", "<leader>fd", ":Telescope diagnostics<CR>", opts)
keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
keymap("n", "<leader>fs", ":Telescope file_browser<CR>", opts)

-- hop keymaps
keymap('', '<leader>sp', ':HopPattern<cr>', opts)
keymap('', '<leader>sw', ':HopWord<cr>', opts)
keymap('', '<leader>sc', ':HopChar2<cr>', opts)
keymap('', '<leader>sl', ':HopLine<cr>', opts)

-- disable some keymaps
keymap("n", "<A-CR>", "<Nop>", opts)

-- ufo
keymap('n', 'zR', ":lua require('ufo').openAllFolds", opts)
keymap('n', 'zM', ":lua require('ufo').closeAllFolds", opts)
