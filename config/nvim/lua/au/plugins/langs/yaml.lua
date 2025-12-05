vim.lsp.enable('yamlls')

---@type [LazyPluginSpec]
return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                yamlls = {},
            },
        },
    },
}
