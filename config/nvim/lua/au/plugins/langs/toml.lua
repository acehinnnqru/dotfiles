local utils = require("au.utils")

if not utils.has_command("taplo") then
    return {}
end

vim.lsp.enable("taplo")

utils.install_ts({ "toml" })

---@type [LazyPluginSpec]
return {
    {
        "nvimtools/none-ls.nvim",
        opts = function(_, opts)
            local nls = require("null-ls")
            table.insert(opts.sources, nls.builtins.formatting.taplo)
        end,
    },

    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                taplo = {},
            },
        },
    },
}
