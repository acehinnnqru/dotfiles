return {
    {
        "jay-babu/mason-null-ls.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "cspell", "alex", "proselint", "vale" })
        end,
    },

    {
        "jose-elias-alvarez/null-ls.nvim",
        opts = function(_, opts)
            local nls = require("null-ls")
            table.insert(opts.sources, nls.builtins.diagnostics.cspell)
            table.insert(opts.sources, nls.builtins.code_actions.cspell)

            table.insert(opts.sources, nls.builtins.diagnostics.alex)
            table.insert(opts.sources, nls.builtins.diagnostics.proselint)
            table.insert(opts.sources, nls.builtins.diagnostics.vale)
            return opts
        end,
    },
}
