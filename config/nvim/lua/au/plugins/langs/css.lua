local utils = require("au.utils")

if not utils.is_lang_enabled("CSS") then
    return {}
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "css" })
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        opts = function(_, opts)
            local nls = require("null-ls")
            table.insert(opts.sources, nls.builtins.formatting.stylelint)
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                cssls = {},
            },
            setup = {
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
