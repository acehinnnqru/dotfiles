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
            disable = function(lang, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["aa"] = { query = "@parameter.outer", desc = "a argument" },
                        ["ia"] = { query = "@parameter.inner", desc = "inner part of a argument" },
                        ["af"] = { query = "@function.outer", desc = "a function region" },
                        ["if"] = { query = "@function.inner", desc = "inner part of a function region" },
                        ["ac"] = { query = "@class.outer", desc = "a of a class" },
                        ["ic"] = { query = "@class.inner", desc = "inner part of a class region" },
                        ["al"] = { query = "@loop.outer", desc = "a loop" },
                        ["il"] = { query = "@loop.inner", desc = "inner part of a loop" },
                    },
                },
            },
            nvim_next = {
                enable = true,
                textobjects = {
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]a"] = { query = "@parameter.outer", desc = "Next argument start" },
                            ["]f"] = { query = "@function.outer", desc = "Next function start" },
                            ["]c"] = { query = "@class.outer", desc = "Next class start" },
                            ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
                        },
                        goto_next_end = {
                            ["]A"] = { query = "@parameter.outer", desc = "Next argument end" },
                            ["]F"] = { query = "@function.outer", desc = "Next function end" },
                            ["]C"] = { query = "@class.outer", desc = "Next class end" },
                            ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
                        },
                        goto_previous_start = {
                            ["[a"] = { query = "@parameter.outer", desc = "Previous argument start" },
                            ["[f"] = { query = "@function.outer", desc = "Previous function start" },
                            ["[c"] = { query = "@class.outer", desc = "Previous class start" },
                            ["[l"] = { query = "@loop.outer", desc = "Previous loop start" },
                        },
                        goto_previous_end = {
                            ["[A"] = { query = "@parameter.outer", desc = "Previous argument end" },
                            ["[F"] = { query = "@function.outer", desc = "Previous function end" },
                            ["[C"] = { query = "@class.outer", desc = "Previous class end" },
                            ["[L"] = { query = "@loop.outer", desc = "Previous loop end" },
                        },
                    },
                },
            },
        },
        config = function(_, opts)
            require("nvim-next.integrations").treesitter_textobjects()

            require("nvim-treesitter.configs").setup(opts)
            require("ts_context_commentstring").setup({})
            vim.g.skip_ts_context_commentstring_module = true
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

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },

    {
        "ghostbuster91/nvim-next",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
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
