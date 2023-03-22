return {
	"rmagatti/auto-session",
	init = function()
		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
	end,
	config = function()
		require("auto-session").setup({
			log_level = "error",
			auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
			pre_save_cmds = {
				function()
					require("neo-tree.sources.manager").close_all()
					require("dapui").close()
                    vim.cmd "cclose"
					vim.notify("closed all")
				end,
			},
		})
	end,
}
