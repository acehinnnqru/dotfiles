local utils = require("au.utils")

if not utils.is_lang_enabled("ZIG") then
    return {}
end

vim.lsp.enable('zls')

---@type [LazyPluginSpec]
return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                zls = {},
            },
        },
    },
}
