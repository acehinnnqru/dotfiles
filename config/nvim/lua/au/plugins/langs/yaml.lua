local utils = require("au.utils")

vim.lsp.enable("yamlls")

utils.install_ts({ "yaml" })

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
