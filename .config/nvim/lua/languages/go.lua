return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "go", "gomod" })
		end,
	},
    {
        "jay-babu/mason-null-ls.nvim",
        dependencies = {
            "jose-elias-alvarez/null-ls.nvim",
            "williamboman/mason.nvim",
        },
        opts = function (_, opts)
            vim.list_extend(opts.ensure_installed, {"golangci-lint", "goimports", "gofmt"})
        end
    },
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			table.insert(opts.ensure_installed, "gopls")
			return opts
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		opts = function(_, opts)
			local nls = require("null-ls")
			table.insert(opts.sources, nls.builtins.code_actions.gomodifytags)
			table.insert(opts.sources, nls.builtins.diagnostics.golangci_lint)
            table.insert(opts.sources, nls.builtins.formatting.goimports)
            table.insert(opts.sources, nls.builtins.formatting.gofmt)
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				gopls = {
					settings = {},
				},
			},
			setup = {
				gopls = function(_, opts)
					require("lspconfig").gopls.setup(opts)
				end,
			},
		},
	},
}
