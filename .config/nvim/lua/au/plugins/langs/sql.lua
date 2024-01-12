return {
    {
        "nvimtools/none-ls.nvim",
        opts = function(_, opts)
            local nls = require("null-ls")
            table.insert(opts.sources, nls.builtins.formatting.sqlfluff)
            nls.builtins.formatting.sqlfluff.with({
                extra_args = { "--dialect", "postgres" }, -- change to your dialect
            })
        end,
    },
    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            table.insert(opts.ensure_installed, "sqlls")
            return opts
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                sqlls = {},
            },
        },
    },
}
