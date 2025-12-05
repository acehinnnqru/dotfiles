local utils = require("au.utils")

if not utils.is_lang_enabled("C") then
    return {}
end

vim.lsp.enable('clangd')

---@type [LazyPluginSpec]
return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                clangd = {},
            },
        },
    },
}
