local utils = require("au.utils")

if not utils.is_lang_enabled("RUST") then
    return {}
end

return {
    -- modified treesitter config
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "ron", "toml", "rust" })
        end,
    },

    {
        "mrcjkb/rustaceanvim",
        version = "^4",
        ft = { "rust" },
        command = "RustLsp",
        config = function()
            vim.g.rustaceanvim = {
                tools = {
                    on_initialized = function()
                        vim.cmd([[
                            augroup RustLSP
                            autocmd CursorHold                      *.rs silent! lua vim.lsp.buf.document_highlight()
                            autocmd CursorMoved,InsertEnter         *.rs silent! lua vim.lsp.buf.clear_references()
                            autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
                            augroup END
                            ]])
                    end,
                    inlay_hints = {
                        auto = false,
                    },
                },
                server = {
                    settings = {
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
