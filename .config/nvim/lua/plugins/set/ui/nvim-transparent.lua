return {
	"xiyaowong/nvim-transparent",
	event = "VimEnter",
	config = function()
		require("transparent").setup({
			enable = true,
		})
	end,
}
