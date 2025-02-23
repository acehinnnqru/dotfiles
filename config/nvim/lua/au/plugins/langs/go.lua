local utils = require("au.utils")

if not utils.is_lang_enabled("GO") then
    return {}
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "gomod", "go" })
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        opts = function(_, opts)
            local nls = require("null-ls")
            table.insert(opts.sources, nls.builtins.code_actions.gomodifytags)
            table.insert(opts.sources, nls.builtins.diagnostics.golangci_lint)
            table.insert(opts.sources, nls.builtins.formatting.goimports)
            table.insert(opts.sources, nls.builtins.formatting.gofmt)
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            vim.notify("loaded")

            require("au.utils").lsp_on_attach(function(client, _)
                if client.name == "gopls" and not client.server_capabilities.semanticTokensProvider then
                    local semantic = client.config.capabilities.textDocument.semanticTokens
                    client.server_capabilities.semanticTokensProvider = {
                        full = true,
                        legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
                        range = true,
                    }
                end
            end)
            if opts.servers == nil then
                opts.servers = {}
            end
            opts.servers["gopls"] = {
                settings = {
                    gopls = {
                        gofumpt = true,
                        codelenses = {
                            gc_details = false,
                            generate = true,
                            regenerate_cgo = true,
                            run_govulncheck = true,
                            test = true,
                            tidy = true,
                            upgrade_dependency = true,
                            vendor = true,
                        },
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            compositeLiteralTypes = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },
                        analyses = {
                            fieldalignment = false,
                            nilness = true,
                            unusedparams = true,
                            unusedwrite = true,
                            useany = true,
                        },
                        usePlaceholders = true,
                        completeUnimported = true,
                        staticcheck = true,
                        directoryFilters = {
                            "-.git",
                            "-.vscode",
                            "-.idea",
                            "-.vscode-test",
                            "-node_modules",
                            "-.direnv",
                        },
                        semanticTokens = true,
                    },
                },
            }

            return opts
        end,
    },
}
