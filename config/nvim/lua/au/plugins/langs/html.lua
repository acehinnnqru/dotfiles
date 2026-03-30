local utils = require("au.utils")

if not utils.has_command("prettierd") then
    return {}
end

vim.lsp.enable("html")

---@type [LazyPluginSpec]
return {
    {
        "nvimtools/none-ls.nvim",
        opts = function(_, opts)
            local nls = require("null-ls")
            table.insert(opts.sources, nls.builtins.formatting.prettierd)
        end,
    },
}
