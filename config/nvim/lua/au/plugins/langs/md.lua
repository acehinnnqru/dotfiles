local utils = require("au.utils")

vim.lsp.enable("marksman")

utils.install_ts({ "markdown", "markdown_inline" })

---@type [LazyPluginSpec]
return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                marksman = {},
            },
        },
    },
}
