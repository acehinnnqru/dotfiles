-- remap leader key to space
vim.keymap.set("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local utils = require("au.utils")

-- set core options
utils.set_vim_opts(require("au.core.options"))
-- set core keymaps
utils.set_keymaps(require("au.core.keymaps"))

