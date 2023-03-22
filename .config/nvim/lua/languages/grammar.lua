return {
	{
		"jay-babu/mason-null-ls.nvim",
		dependencies = {
			"jose-elias-alvarez/null-ls.nvim",
			"williamboman/mason.nvim",
		},
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "cspell", "alex", "proselint", "vale" })
		end,
	},
}
