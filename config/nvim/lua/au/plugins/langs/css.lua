local utils = require("au.utils")

if not utils.has_command("cssls") then
    return {}
end

vim.lsp.enable("cssls")

utils.install_ts({ "css" })

---@type [LazyPluginSpec]
return {
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
        },
    },
}
