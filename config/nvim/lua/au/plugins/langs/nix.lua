local utils = require("au.utils")

if not utils.has_command("nix") or not utils.has_command("nil") then
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
