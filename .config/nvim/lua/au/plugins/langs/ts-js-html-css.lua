return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "javascript", "html", "css", "typescript" })
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "eslint_d", "prettierd", "stylelint" })
            local nls = require("null-ls")
            table.insert(opts.sources, nls.builtins.formatting.prettierd)
            table.insert(opts.sources, nls.builtins.code_actions.eslint_d)
            table.insert(opts.sources, nls.builtins.formatting.stylelint)
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = function(_, opts)
            table.insert(opts.ensure_installed, "html")
            table.insert(opts.ensure_installed, "cssls")
            return opts
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                tsserver = {
                    init_options = {
                        providePrefixAndSuffixTextForRename = true,
                        allowRenameOfImportPath = true,
                        maxTsServerMemory = 12288,
                    },
                    preferences = {
                        importModuleSpecifierPreference = "relative",
                    },
                },
                cssls = {},
            },
            setup = {
                tsserver = function(_, opts)
                    require("au.utils").lsp_on_attach(function(client, _)
                        if client.name == "tsserver" then
                            client.server_capabilities.documentFormattingProvider = false
                            client.server_capabilities.documentRangeFormattingProvider = false
                        end
                    end)

                    vim.api.nvim_create_autocmd("FileType", {
                        pattern = "html,typescript,typescriptreact,javascript,javascriptreact,css,less,vue",
                        callback = function()
                            vim.opt_local.shiftwidth = 2
                            vim.opt_local.tabstop = 2
                        end,
                    })

                    require("lspconfig").tsserver.setup(opts)
                end,
                cssls = function(_, opts)
                    local capabilities = vim.lsp.protocol.make_client_capabilities()
                    capabilities.textDocument.completion.completionItem.snippetSupport = true

                    opts.capabilities = capabilities
                    require("lspconfig").cssls.setup({
                        capabilities = capabilities,
                    })
                end,
            },
        },
    },
}
