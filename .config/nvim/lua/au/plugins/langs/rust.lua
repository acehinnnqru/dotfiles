return {
    -- Extend auto completion
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            {
                "Saecki/crates.nvim",
                event = { "BufRead Cargo.toml" },
                config = true,
            },
        },
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
            local cmp = require("cmp")
            if opts.window == nil then
                opts.window = {}
            end
            opts.window.documentation = false
            opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
                { name = "crates", priority = 750 },
            }))
        end,
    },

    -- modified treesitter config
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "ron", "toml", "rust" })
        end,
    },

    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            table.insert(opts.ensure_installed, "codelldb")
            return opts
        end,
    },

    {
        "mrcjkb/rustaceanvim",
        version = "v3",
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
