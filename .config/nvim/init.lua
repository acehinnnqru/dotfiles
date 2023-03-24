-- install lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local lazy_specs = {}
local lazy_options = {
    install = {
        missing = true,
	colorscheme = {},
    },
    change_detection = {
        enabled = false,
	notify = false,
    }
}

-- setup lazy
require("lazy").setup(plugins, opts)

-- init core
require("au.core")
