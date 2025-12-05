local utils = require("au.utils")

if not utils.is_lang_enabled("TOML") then
    return {}
end

vim.lsp.enable('taplo')

---@type [LazyPluginSpec]
return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "toml" })
        end,
    },

    {
        "nvimtools/none-ls.nvim",
        opts = function(_, opts)
            local nls = require("null-ls")
            table.insert(opts.sources, nls.builtins.formatting.taplo)
        end,
    },

    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                taplo = {},
            },
        },
    },
}
