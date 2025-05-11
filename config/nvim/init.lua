-- init core options and keymaps
require("au.core")

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

vim.o.runtimepath = table.concat({ vim.o.runtimepath, lazypath }, ",")

-- determine plugins to load based on current environment.
--      environment choices: nvim, vscode, gui
local lazy_plugin_specs = function()
    -- generate specs
    local gen = function(specs)
        local s = {}
        for k, v in ipairs(specs) do
            s[k] = { import = v }
        end
        return s
    end

    return gen({ "au.plugins.basics", "au.plugins.langs" })
end

local lazy_options = function()
    return {
        lockfile = vim.fn.stdpath("state") .. "/lazy/lazy-lock.json",
        lazy = true,
        ui = {
            border = "rounded",
            icons = {
                cmd = "cmd:",
                config = "conf:",
                debug = "dbg:",
                event = "event:",
                favorite = "favorite:",
                ft = "ft:",
                init = "init:",
                import = "import:",
                keys = "keys:",
                lazy = "lazy:",
                loaded = "loaded:",
                not_loaded = "unloaded:",
                plugin = "plugin:",
                runtime = "runtime:",
                require = "require:",
                source = "source:",
                start = "start:",
                task = "task:",
                list = {
                    "‒",
                },
            },
        },
        spec = lazy_plugin_specs(),
        install = {
            missing = true,
            colorscheme = {},
        },
        change_detection = {
            enabled = false,
            notify = false,
        },
    }
end

-- key to call Lazy interface
vim.keymap.set("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- setup lazy
require("lazy").setup(lazy_options())
