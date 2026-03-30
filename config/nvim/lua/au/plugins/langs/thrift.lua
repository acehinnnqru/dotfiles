local utils = require("au.utils")

if not utils.has_command("thriftls") then
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
