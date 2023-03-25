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

local function get_lazy_spec(specs)
    local s = {}
    for k, v in ipairs(specs) do
        s[k] = { import = v }
    end
    return s
end

local lazy_specs = {}
if env.minimal then
    lazy_specs.spec = get_lazy_spec({ "au.plugins.minimal", })
else
    local e = env.environment
    if e == "nvim" then
        lazy_specs.spec = get_lazy_spec({ "au.plugins.minimal", "au.plugins.extends" })
    elseif e == "vscode" then
        lazy_specs.spec = {}
    elseif e == "gui" then
        lazy_specs.spec = {}
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
