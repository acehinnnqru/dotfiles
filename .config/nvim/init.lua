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

local env = require("au.env")

local lazy_specs = {}

if env.minimal then
    lazy_specs = {}
else
    local e = env.environment
    if e == "nvim" then
        lazy_specs = {}
    elseif e == "vscode" then
        lazy_specs = {}
    elseif e == "gui" then
        lazy_specs = {}
    end
end

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

-- init core
require("au.core")

-- key to call Lazy interface
vim.keymap.set("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- setup lazy
require("lazy").setup(lazy_specs, lazy_options)
