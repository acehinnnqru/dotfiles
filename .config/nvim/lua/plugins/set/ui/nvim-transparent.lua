return {
	"xiyaowong/nvim-transparent",
	event = "VimEnter",
	config = function()
		require("transparent").setup({})
		vim.g.transparent_enabled = true
	end,
}
