local utils = require("au.utils")

if not utils.is_lang_enabled("LUA") then
    return {}
end

local nvim_app_env = os.getenv("NVIM_APPNAME")
local nvim_app = nvim_app_env and nvim_app_env or "nvim"

---@type [LazyPluginSpec]
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
        opts = function(_, opts)
            if opts.servers == nil then
                opts.servers = {}
            end
            opts.servers["lua_ls"] = {
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
                                vim.fn.expand("$VIMRUNTIME/lua"),
                                vim.fn.expand("~/.local/share/" .. nvim_app .. "/lazy"),
                                "${3rd}/luv/library",
                            },
                            checkThirdParty = false,
                            ignoreDir = { ".git", "dist", "node_modules", "build", ".direnv", ".envrc" },
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
            }
            return opts
        end,
    },
}
