local utils = require("au.utils")

if not utils.is_lang_enabled("C") then
    return {}
end

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
