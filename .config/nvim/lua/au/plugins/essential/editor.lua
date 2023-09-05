return {
    -- im-select
    {
        "keaising/im-select.nvim",
        opts = {
            set_previous_events = {},
        },
        event = "VeryLazy",
    },
    -- auto pairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },

    -- surround
    {
        "kylechui/nvim-surround",
        event = "InsertEnter",
        config = true,
    },

    -- comment plugin
    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        version = false,
        config = function(_, opts)
            require("mini.comment").setup(opts)
        end,
    },

    -- indent
    -- support context, line start
    {
        "lukas-reineke/indent-blankline.nvim",
        branch = "v3",
        event = "VeryLazy",
        config = function(_, opts)
            require("ibl").setup(opts)
        end,
        opts = {
            filetype_exclude = { "help", "alpha", "dashboard", "lazy" },
            show_trailing_blankline_indent = false,
            show_end_of_line = false,
            space_char_blankline = " ",
            scope = {
                enabled = false,
            },
        },
    },

    -- neo tree instead of original netrw
    {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
        branch = "v2.x",
        cmd = "Neotree",
        keys = {
            {
                "<leader>fe",
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = require("au.utils").get_root() })
                end,
                desc = "Explorer NeoTree (root dir)",
            },
            {
                "<leader>fE",
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
                end,
                desc = "Explorer NeoTree (cwd)",
            },
            { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
            { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
        },
        init = function()
            vim.g.neo_tree_remove_legacy_commands = 1
            -- override the netrw when opening a dir
            if vim.fn.argc() == 1 then
                local stat = vim.loop.fs_stat(vim.fn.argv(0))
                if stat and stat.type == "directory" then
                    require("neo-tree")
                end
            end
        end,
        opts = {
            popup_border_style = "rounded",
            filesystem = {
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
                bind_to_cwd = false,
                follow_current_file = true,
            },
            window = {
                position = "float",
                mappings = {
                    ["<space>"] = "none",
                },
            },
        },
        config = function(_, opts)
            require("neo-tree").setup(opts)
        end,
    },
}
