local utils = require("au.utils")

if not utils.has_command("clangd") then
    return {}
end

vim.lsp.enable("clangd")

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
