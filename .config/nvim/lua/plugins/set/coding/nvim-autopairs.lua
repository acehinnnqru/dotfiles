return {
	"windwp/nvim-autopairs",
	event = "VeryLazy",
	config = function(_, opts)
		require("nvim-autopairs").setup(opts)
	end,
}
