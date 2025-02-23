local utils = require("au.utils")

if not utils.is_lang_enabled("CSS") then
    return {}
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "css" })
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        opts = function(_, opts)
            local nls = require("null-ls")
            table.insert(opts.sources, nls.builtins.formatting.stylelint)
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                cssls = {},
            },
        },
    },
}
