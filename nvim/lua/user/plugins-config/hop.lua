-- place this in one of your configuration file(s)
local opts = {
    noremap = true,
    silent = true
}
local keymap = vim.api.nvim_set_keymap

keymap('', '<leader>sp', ':HopPattern<cr>', opts)
keymap('', '<leader>sw', ':HopWord<cr>', opts)
keymap('', '<leader>sc', ':HopChar2<cr>', opts)
keymap('', '<leader>sl', ':HopLine<cr>', opts)

require('hop').setup{}
