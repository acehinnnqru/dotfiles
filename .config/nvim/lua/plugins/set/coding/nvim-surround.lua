return {
	"kylechui/nvim-surround",
	event = "InsertEnter",
	config = function(_, opts)
		require("nvim-surround").setup(opts)
	end,
}
