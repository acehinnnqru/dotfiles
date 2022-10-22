local function vim_opt_load(opts)
    for k, v in pairs(opts) do
        vim.opt[k] = v
    end
end

local user_opts = {
    -- utils options
    clipboard = "unnamedplus",
    cmdheight = 1,
    completeopt = { "menu", "menuone", "noselect" },
    conceallevel = 0,
    mouse = "a",
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
    writebackup = false,
    expandtab = true,
    cursorline = true,
    cursorcolumn = true,
    number = true,
    relativenumber = true,
    signcolumn = "yes",
    tabstop = 4,
    autoindent = true,
    smartindent = true,
    shiftwidth = 4,
    shortmess = "atI",
    showmode = false,
    termguicolors = true,
}

vim_opt_load(user_opts)
vim.g.python3_host_prog = '/opt/homebrew/bin/python3'
