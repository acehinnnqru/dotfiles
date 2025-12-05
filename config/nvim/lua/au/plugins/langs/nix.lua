local utils = require("au.utils")

if not utils.is_lang_enabled("NIX") then
    return {}
end

vim.lsp.enable('nil_ls')

---@type [LazyPluginSpec]
return {
    {
        "nvimtools/none-ls.nvim",
        opts = function(_, opts)
            local nls = require("null-ls")
            table.insert(opts.sources, nls.builtins.formatting.alejandra)
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                nil_ls = {},
            },
        },
    },
}
