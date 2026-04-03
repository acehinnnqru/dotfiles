local utils = require("au.utils")

if not utils.has_command("zls") then
    return {}
end

vim.lsp.enable("zls")

utils.install_ts({ "zig" })

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
