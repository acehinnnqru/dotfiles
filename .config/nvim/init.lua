-- init core options and keymaps
require("au.core")


local env = require("au.env")

-- only load core options and keymaps if in minimal mode.
-- set minimal mode:
--      1. write a file `local_env.lua` in ./lua/au/ and put `return {minimal=true}` in it.
--      2. using an env variable, `NVIM_MINIMAL`, to open nvim like `NVIM_MINIMAL=1 nvim`
if env.minimal then
    return
end


-- install lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- determine plugins to load based on current environment.
--      enviroment choices: nvim, vscode, gui
local lazy_plugins = function()
    local gen = function(specs)
        local s = {}
        for k, v in ipairs(specs) do
            s[k] = { import = v }
        end
        return s
    end

    local e = env.environment
    local plugins = {}
    if e == "nvim" then
        plugins.spec = gen({ "au.plugins.minimal", "au.plugins.extends" })
    elseif e == "vscode" then
        plugins.spec = {}
    elseif e == "gui" then
        plugins.spec = {}
    end

    return plugins
end

local lazy_options = function()
    return {
        install = {
            missing = true,
            colorscheme = {},
        },
        change_detection = {
            enabled = false,
            notify = false,
        }
    }
end

-- key to call Lazy interface
vim.keymap.set("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- setup lazy
require("lazy").setup(lazy_plugins(), lazy_options())
