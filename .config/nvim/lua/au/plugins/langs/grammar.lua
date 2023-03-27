return {
    {
        "jay-babu/mason-null-ls.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "cspell", "alex", "proselint", "vale" })
        end,
    },
}
