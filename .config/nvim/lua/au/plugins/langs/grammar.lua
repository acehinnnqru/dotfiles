return {
    {
        "jay-babu/mason-null-ls.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "alex", "proselint", "misspell", "vale" })
        end,
    },

    {
        "jose-elias-alvarez/null-ls.nvim",
        opts = function(_, opts)
            local nls = require("null-ls")
            table.insert(opts.sources, nls.builtins.diagnostics.alex)
            table.insert(opts.sources, nls.builtins.code_actions.proselint)
            table.insert(opts.sources, nls.builtins.diagnostics.vale)
            table.insert(opts.sources, nls.builtins.diagnostics.misspell)
            return opts
        end,
    },
}
