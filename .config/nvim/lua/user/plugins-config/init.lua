require "impatient"

require "user.plugins-config.alpha"
require "user.plugins-config.nvim-treesitter"
require "user.plugins-config.nvim-web-devicons"
require "user.plugins-config.cmp-config"
require "user.plugins-config.hop"
require "user.plugins-config.telescope"
require("user.plugins-config.orgmode")

-- show blank lines
vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
    show_end_of_line = true,
    space_char_blankline = " ",
}

vim.o.foldcolumn = '0' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

require('ufo').setup({
    open_fold_hl_timeout = 0,
    provider_selector = function(bufnr, filetype, buftype)
        return { 'treesitter', 'indent' }
    end
})

require("symbols-outline").setup()


-- other tools config
require 'nvim-autopairs'.setup {}
require 'nvim-surround'.setup {}

-- [[ require("transparent").setup({ ]]
-- [[     enable = true, ]]
-- [[ }) ]]

require('lualine').setup {}
require("bufferline").setup {
    options = {
        diagnostics = "nvim_lsp",
        show_tab_indicators = true,
        show_close_icon = false,
    }
}

require('Comment').setup {
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
}

require('gitsigns').setup {
    current_line_blame = true,
    current_line_blame_opts = {
        delay = 100,
    }
}

require("todo-comments").setup({})

require("bqf").setup({

})

require("colorizer").setup()
