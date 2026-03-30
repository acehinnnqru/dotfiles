local utils = require("au.utils")

if not utils.has_command("zls") then
    return {}
end

vim.lsp.enable("zls")

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
