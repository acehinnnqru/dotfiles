local function vim_opt_load(opts)
	for k, v in pairs(opts) do
		vim.opt[k] = v
	end
end

local user_opts = {
	-- utils options
	clipboard = "unnamedplus", -- support system clipboard
	cmdheight = 1, -- set command line height
	completeopt = { "menu", "menuone", },
	conceallevel = 0, -- show * markup for bold and italic
	mouse = "a", -- enable mouse mode
	showtabline = 2,
	pumheight = 10,

	-- search options
	hlsearch = true,
	ignorecase = true,
	smartcase = true,

	-- view options
	splitbelow = true,
	splitright = true,

	-- editor options
	fileencoding = "utf-8",
	undofile = true,
	updatetime = 300,
    joinspaces = false,
	writebackup = false,
	cursorline = true,
	cursorcolumn = true,
	number = true,
	relativenumber = true,
	signcolumn = "yes",
	tabstop = 4,
	smartindent = true,
	shiftwidth = 4,
	expandtab = true,
	shortmess = "atI",
	showmode = false,
	termguicolors = true, -- support true color
	wildmode = "longest:full,full", -- Command-line completion mode
}

vim_opt_load(user_opts)
vim.g.python3_host_prog = "/opt/homebrew/bin/python3"
