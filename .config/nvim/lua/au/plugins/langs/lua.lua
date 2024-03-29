return {
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "stylua" })
            local nls = require("null-ls")
            table.insert(opts.sources, nls.builtins.formatting.stylua)
            return opts
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "lua", "vimdoc", "luadoc" })
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
