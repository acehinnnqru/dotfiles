return {
	"echasnovski/mini.comment",
    keys = { "gc", "gcc" },
	opts = {
		hooks = {
			pre = function()
				require("ts_context_commentstring.internal").update_commentstring({})
			end,
		},
	},
	config = function(_, opts)
		require("mini.comment").setup(opts)
	end,
}
