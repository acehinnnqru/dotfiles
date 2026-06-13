local utils = require("au.utils")

if not utils.has_command("rust-analyzer") then
    return {}
end

utils.install_ts({ "rust" })

---@type LazyPluginSpec[]
return {
    {
        "mrcjkb/rustaceanvim",
        ft = { "rust" },
        version = "^9",
        config = function()
            vim.g.rustaceanvim = {
                server = {
                    settings = {
                        -- rustaceanvim would automaticly set the built-in lsp
                        ["rust-analyzer"] = {
                            cargo = {
                                allFeatures = true,
                                loadOutDirsFromCheck = true,
                                runBuildScripts = true,
                            },
                            checkOnSave = true,
                            check = {
                                enable = true,
                                command = "clippy",
                                allTargets = true,
                            },
                            files = {
                                excludeDirs = { ".direnv", ".envrc", ".git", ".idea" },
                                watcherExclude = { ".direnv", ".envrc", ".git", ".idea" },
                            },
                            procMacro = {
                                enable = true,
                                ignored = {
                                    ["async-trait"] = { "async_trait" },
                                    ["napi-derive"] = { "napi" },
                                    ["async-recursion"] = { "async_recursion" },
                                },
                            },
                        },
                    },
                },
            }
        end,
    },
}
