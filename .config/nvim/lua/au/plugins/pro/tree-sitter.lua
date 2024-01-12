return {
    -- tree-sitter
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build = ":TSUpdate",
        event = "VeryLazy",
        opts = {
            ensure_installed = {
                "gitignore",
                "comment",
                "regex",
            },
            auto_install = true,
            sync_install = false,
            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
            incremental_selection = {
                enable = true,
            },
            context_commentstring = {
                enable = true,
            },
            disable = function(lang, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    -- code context using tree-sitter
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = true,
        keys = {
            { "<leader>tc", "<cmd>TSContextToggle<cr>", desc = "Toggle TSContext" },
        },
    },

    -- comment enhanced using tree-sitter
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        lazy = true,
    },

    -- re-declare mini.comment to add tree-sitter support
    -- the options will be merged.
    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        version = false,
        opts = {
            hooks = {
                pre = function()
                    require("ts_context_commentstring.internal").update_commentstring({})
                end,
            },
        },
        config = function(_, opts)
            require("mini.comment").setup(opts)
        end,
    },

    -- re-declare ufo to add tree-sitter support
    -- the options will be merged.
    {
        "kevinhwang91/nvim-ufo",
        event = "VeryLazy",
        dependencies = { "kevinhwang91/promise-async" },
        opts = function(opts)
            if not opts then
                opts = {}
            end
            if opts.provider_selector then
                table.insert(opts.provider_selector, "treesitter")
            end

            return opts
        end,
    },
}
