local utils = require("au.utils")

if not utils.is_lang_enabled("LUA") then
    return {}
end

return {
    {
        "nvimtools/none-ls.nvim",
        opts = function(_, opts)
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
                                ignoreDir = { ".git", "dist", "node_modules", "build", ".direnv" }
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