return {
    -- enable mouse
    mouse = "a",

    -- integrated with clipboard
    -- unix
    clipboard = "unnamedplus",

    -- set conceal level
    conceallevel = 0,

    -- search options
    hlsearch = true,
    ignorecase = true,
    smartcase = true,

    -- split view options
    splitbelow = true,
    splitright = true,

    -- tabline options
    showtabline = 1,

    -- pop menu, aka completion menu
    pumheight = 10,
    completeopt = { "menu", "menuone" },

    -- file options
    fileencoding = "utf-8",

    -- enable undofile
    undofile = true,

    --- editor behaviors
    joinspaces = false,
    writebackup = false,

    -- updatetime(millisecond), usage:
    -- 1. CursorHold event time count
    -- 2. The save interval of the swap file
    updatetime = 300,

    -- indent
    smartindent = true,
    -- this is used for (un)indenting
    shiftwidth = 4,
    -- default tab equal space count
    tabstop = 4,
    -- default expand tab into spaces
    expandtab = true,

    -- shortmess (refer to :h shortmess)
    shortmess = "atI",
    showmode = false,

    -- for command line completion
    wildmode = "longest:full,full",

    -- appearance
    -- support true color
    termguicolors = true,

    -- gutter options
    number = true,
    relativenumber = true,

    -- show signcolumn
    signcolumn = "yes",
}
