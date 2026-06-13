local utils = require("au.utils")

if not utils.has_command("sqlls") then
    return {}
end

vim.lsp.enable("sqlls")

utils.install_ts({ "sql" })

---@type LazyPluginSpec[]
return {
    {
        "nvimtools/none-ls.nvim",
        opts = function(_, opts)
            local nls = require("null-ls")
            table.insert(opts.sources, nls.builtins.formatting.sqlfluff)
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                sqlls = {},
            },
        },
    },
}
