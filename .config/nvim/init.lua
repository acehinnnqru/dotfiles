-- boostrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end

vim.opt.runtimepath:prepend(lazypath)

vim.g.mapleader = " "

local opts = {
    defaults = {
        lazy = true,
    },
    install = {
        colorscheme = { "github-theme" }
    }
}
-- load lazy.nvim
require("lazy").setup("plugins", opts)

require "user.colorscheme"
require "user.plugins-config"
require "user.options"
require "user.keymaps"
require "user.lsp"
