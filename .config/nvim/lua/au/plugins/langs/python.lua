require("au.utils").set_g_opts({
    python3_host_prog = "/opt/homebrew/bin/python3",
})

return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "python" })
        end,
    },
    {
        "jay-babu/mason-null-ls.nvim",
        dependencies = {
            "jose-elias-alvarez/null-ls.nvim",
            "williamboman/mason.nvim",
        },
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "flake8", "autopep8", "isort" })
        end,
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        opts = function(_, opts)
            local nls = require("null-ls")
            table.insert(opts.sources, nls.builtins.diagnostics.flake8)
            table.insert(opts.sources, nls.builtins.formatting.autopep8)
            table.insert(opts.sources, nls.builtins.formatting.isort)
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                pylsp = {
                    plugins = {
                        pycodestyle = {
                            ignore = { "W391", "E501" },
                            maxLineLength = 120,
                        },
                    },
                },
            },
        },
    },
}
