local utils = require("au.utils")

if not utils.has_command("tsserver") then
    return {}
end

vim.lsp.enable("ts_ls")

utils.install_ts({ "javascript", "typescript", "tsx" })

---@type [LazyPluginSpec]
return {
    {
        "nvimtools/none-ls.nvim",
        opts = function(_, opts)
            local nls = require("null-ls")
            table.insert(opts.sources, nls.builtins.formatting.prettierd)
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
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

            if opts.servers == nil then
                opts.servers = {}
            end

            opts.servers["ts_ls"] = {
                init_options = {
                    providePrefixAndSuffixTextForRename = true,
                    allowRenameOfImportPath = true,
                    maxTsServerMemory = 12288,
                },
                preferences = {
                    importModuleSpecifierPreference = "relative",
                },
            }

            return opts
        end,
    },
}
