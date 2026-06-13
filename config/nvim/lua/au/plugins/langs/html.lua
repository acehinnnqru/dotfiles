local utils = require("au.utils")

if not utils.has_any_command({ "prettierd", "oxfmt" }) then
    return {}
end

vim.lsp.enable("html")

utils.enable_or_ignore_lsp("oxfmt", "oxfmt")

utils.install_ts({ "html" })

---@type LazyPluginSpec[]
return {
    {
        "nvimtools/none-ls.nvim",
        opts = function(_, opts)
            local nls = require("null-ls")
            if utils.has_command("prettierd") then
                table.insert(opts.sources, nls.builtins.formatting.prettierd)
            end
        end,
    },
}
