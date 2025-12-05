local utils = require("au.utils")

if not utils.is_lang_enabled("THRIFT") then
    return {}
end

vim.lsp.enable('thriftls')

---@type [LazyPluginSpec]
return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                thriftls = {},
            },
        },
    },
}
