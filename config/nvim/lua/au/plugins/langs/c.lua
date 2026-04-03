local utils = require("au.utils")

if not utils.has_command("clangd") then
    return {}
end

vim.lsp.enable("clangd")

utils.install_ts({"c", "cpp"})

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
