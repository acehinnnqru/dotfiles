return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "vue" })
        end,
    },
    {
        "jay-babu/mason-null-ls.nvim",
        dependencies = {
            "jose-elias-alvarez/null-ls.nvim",
            "williamboman/mason.nvim",
        },
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "eslint_d", "prettierd" })
            return opts
        end,
    },

    {
        "jose-elias-alvarez/null-ls.nvim",
        opts = function(_, opts)
            local nls = require("null-ls")
            table.insert(opts.sources, nls.builtins.formatting.prettierd)
            table.insert(opts.sources, nls.builtins.code_actions.eslint_d)
            return opts
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = function(_, opts)
            table.insert(opts.ensure_installed, "volar")
            return opts
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                volar = {
                    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
                },
            },
            setup = {
                volar = function(_, opts)
                    vim.api.nvim_create_autocmd("FileType", {
                        pattern = "html,typescript,typescriptreact,javascript,javascriptreact,css,less,vue",
                        callback = function()
                            vim.opt_local.shiftwidth = 2
                            vim.opt_local.tabstop = 2
                        end,
                    })
                    require("lspconfig").volar.setup(opts)
                end,
            },
        },
    },
}
