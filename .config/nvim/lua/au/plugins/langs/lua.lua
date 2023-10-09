return {
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "jose-elias-alvarez/null-ls.nvim",
            "williamboman/mason.nvim",
        },
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "stylua" })
            return opts
        end,
    },

    {
        "jose-elias-alvarez/null-ls.nvim",
        opts = function(_, opts)
            local nls = require("null-ls")
            table.insert(opts.sources, nls.builtins.formatting.stylua)
            return opts
        end,
    },

    -- correctly setup lspconfig
    {
        "neovim/nvim-lspconfig",
        dependencies = { { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } } },
        opts = {
            -- make sure mason installs the server
            servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = {
                                version = "LuaJIT",
                                path = vim.split(package.path, ";"),
                            },
                            diagnostics = {
                                globals = { "vim" },
                            },
                            workspace = {
                                library = {
                                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                                },
                                checkThirdParty = false,
                            },
                            telemetry = {
                                enable = false,
                            },
                            hint = {
                                enable = true,
                                setType = true,
                                arrayIndex = "Disable",
                            },
                        },
                    },
                },
            },
        },
    },
}
