-- remap leader key to space
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local utils = require("au.utils")

utils.set_vim_opts(require("au.core.options"))
utils.set_keymaps(require("au.core.keymaps"))

