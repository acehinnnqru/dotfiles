return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "toml" })
        end,
    },

    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "taplo" })
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
