local opts = { noremap = true, silent = true }

local keymap = vim.api.nvim_set_keymap

-- window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- buffers navigation
keymap("n", "<leader>bd", ":bdelete<CR>", opts)
keymap("n", "<leader>bp", ":bprevious<CR>", opts)
keymap("n", "<leader>bn", ":bnext<CR>", opts)

-- disable some keymaps
keymap("n", "<A-CR>", "<Nop>", opts)
