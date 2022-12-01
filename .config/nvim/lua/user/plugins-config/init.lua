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

vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

require('ufo').setup({
    provider_selector = function(bufnr, filetype, buftype)
        return {'treesitter', 'indent'}
    end
})

require("symbols-outline").setup()


-- other tools config
require 'nvim-autopairs'.setup {}
require 'nvim-surround'.setup {}

require("transparent").setup({
    enable = true,
})

require('lualine').setup {}
require("bufferline").setup {
    options = {
        diagnostics = "nvim_lsp",
        show_tab_indicators = true,
    }
}

require('Comment').setup {
    pre_hook = function(ctx)
        local U = require 'Comment.utils'

        local location = nil
        if ctx.ctype == U.ctype.block then
            location = require('ts_context_commentstring.utils').get_cursor_location()
        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
            location = require('ts_context_commentstring.utils').get_visual_start_location()
        end

        return require('ts_context_commentstring.internal').calculate_commentstring {
            key = ctx.ctype == U.ctype.line and '__default' or '__multiline',
            location = location,
        }
    end,
}

require('gitsigns').setup {
    current_line_blame = true,
    current_line_blame_opts = {
        delay = 100,
    }
}

require("todo-comments").setup({})
