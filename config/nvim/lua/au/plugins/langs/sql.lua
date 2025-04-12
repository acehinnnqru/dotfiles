local utils = require("au.utils")

if not utils.is_lang_enabled("SQL") then
    return {}
end

---@type [LazyPluginSpec]
return {
    {
        "nvimtools/none-ls.nvim",
        opts = function(_, opts)
            local nls = require("null-ls")
            table.insert(opts.sources, nls.builtins.formatting.sqlfluff)
            nls.builtins.formatting.sqlfluff.with({
                extra_args = { "--dialect", "postgres" }, -- change to your dialect
            })
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
