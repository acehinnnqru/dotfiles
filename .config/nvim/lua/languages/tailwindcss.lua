return {
	{
		"williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
		opts = function(_, opts)
			table.insert(opts.ensure_installed, "tailwindcss")
			return opts
		end,
	},
}
