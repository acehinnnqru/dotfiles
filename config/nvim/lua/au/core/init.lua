-- remap leader key to space
vim.keymap.set("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "
if vim.env.SSH_CONNECTION or vim.env.SSH_TTY then
    vim.g.clipboard = "osc52"
end

local utils = require("au.utils")

-- set core options
utils.set_vim_opts(require("au.core.options"))
-- set core keymaps
utils.set_keymaps(require("au.core.keymaps"))

require("au.core.autocmds")
