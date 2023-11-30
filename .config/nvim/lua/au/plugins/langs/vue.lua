return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "vue" })
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "eslint_d", "prettierd" })
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
