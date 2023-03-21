return {
	"kevinhwang91/nvim-ufo",
	event = "VeryLazy",
	dependencies = { "kevinhwang91/promise-async" },
	opts = {
		open_fold_hl_timeout = 0,
		provider_selector = function(_, _, _)
			return { "treesitter", "indent" }
		end,
	},
	config = function(_, opts)
		vim.o.foldcolumn = "0"
		-- Using ufo provider need a large value, feel free to decrease the value
		vim.o.foldlevel = 99
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true

		require("ufo").setup(opts)
	end,
}
