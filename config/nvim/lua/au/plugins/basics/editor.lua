---@type [LazyPluginSpec]
return {
    -- better fold
    {
        "kevinhwang91/nvim-ufo",
        event = "VeryLazy",
        dependencies = { "kevinhwang91/promise-async" },
        init = function()
            vim.o.foldcolumn = "0"

            -- using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
        end,
        opts = {
            open_fold_hl_timeout = 0,
        },
        config = true,
    },

    -- session using for store work status
    {
        "rmagatti/auto-session",
        lazy = false,
        init = function()
            vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
        end,
        opts = {
            auto_session_suppress_dirs = { "~/", "/" },
            pre_save_cmds = {
                -- close some plugins before saving session
                -- close neo-tree
                function()
                    require("neo-tree.sources.manager").close_all()
                end,
                -- close all quickfix window before saving session
                function()
                    vim.cmd("cclose")
                end,
                function()
                    vim.cmd("AerialCloseAll")
                end,
            },
            session_lens = {
                load_on_setup = false,
            },
        },
        config = true,
        keys = {
            { "<leader>qs", "<cmd>SessionSave<cr>", desc = "Save Session" },
            { "<leader>qd", "<cmd>SessionDelete<cr>", desc = "Delete Session" },
        },
    },

    {
        "chrisgrieser/nvim-early-retirement",
        config = true,
        event = "VeryLazy",
        opts = {
            minimumBufferNum = 10,
        },
    },

    -- todo comments
    -- keywords: `INFO|WARN|TODO|FIXME|TEST|HACK`
    -- usage: using `{keyword}: {text}`
    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        cmd = { "TodoQuickFix", "TodoFzfLua" },
        keys = {
            {
                "]t",
                function()
                    require("todo-comments").jump_next()
                end,
                desc = "Next todo comment",
            },
            {
                "[t",
                function()
                    require("todo-comments").jump_prev()
                end,
                desc = "Previous todo comment",
            },
            { "<leader>xt", "<cmd>TodoQuickFix<cr>", desc = "Todo QuickFix" },
            { "<leader>fx", "<cmd>TodoFzfLua<cr>", desc = "Todo FzfLua" },
        },
        config = function(_, opts)
            require("todo-comments").setup(opts)
        end,
        opts = {},
    },

    -- git signs and jump
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        opts = {
            current_line_blame = true,
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns
                require("au.utils").set_keymaps({
                    { "n", "]h", gs.next_hunk, { desc = "Next Hunk" } },
                    { "n", "[h", gs.prev_hunk, { desc = "Prev Hunk" } },
                    { { "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", { desc = "Stage Hunk" } },
                    { { "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", { desc = "Reset Hunk" } },
                    { "n", "<leader>ghS", gs.stage_buffer, { desc = "Stage Buffer" } },
                    { "n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" } },
                    { "n", "<leader>ghR", gs.reset_buffer, { desc = "Reset Buffer" } },
                    { "n", "<leader>ghp", gs.preview_hunk, { desc = "Preview Hunk" } },
                    {
                        "n",
                        "<leader>ghb",
                        function()
                            gs.blame_line({ full = true })
                        end,
                        { desc = "Blame Line" },
                    },
                    { "n", "<leader>ghd", gs.diffthis, { desc = "Diff This" } },
                    {
                        "n",
                        "<leader>ghD",
                        function()
                            gs.diffthis("~")
                        end,
                        { desc = "Diff This ~" },
                    },
                    {
                        { "o", "x" },
                        "ih",
                        ":<C-U>Gitsigns select_hunk<CR>",
                        { desc = "GitSigns Select Hunk" },
                    },
                }, { buffer = buffer })
            end,
        },
        config = function(_, opts)
            require("gitsigns").setup(opts)
        end,
    },

    -- which key
    {
        "folke/which-key.nvim",
        opts = {},
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.add({
                mode = { "n", "v" },
                { "<leader>b", group = "buffer" },
                { "<leader>c", group = "code" },
                { "<leader>dv", group = "views" },
                { "<leader>g", group = "git" },
                { "<leader>gh", group = "git hunk" },
                { "<leader>h", group = "help" },
                { "<leader>j", group = "jump" },
                { "<leader>q", group = "quit/session" },
                { "<leader>r", group = "restart/reload" },
                { "<leader>f", group = "find" },
                { "<leader>t", group = "toggle" },
                { "<leader>w", group = "windows" },
                { "<leader>x", group = "quickfix" },
                { "[", group = "prev" },
                { "]", group = "next" },
            })
        end,
    },

    -- better quickfix window
    {
        "kevinhwang91/nvim-bqf",
        dependencies = { "junegunn/fzf" },
        ft = { "qf" },
    },

    -- im-select
    {
        "keaising/im-select.nvim",
        lazy = false,
        opts = {
            set_previous_events = {},
        },
        config = function(_, opts)
            require("im_select").setup(opts)
        end,
        event = "VeryLazy",
    },

    -- auto pairs
    {
        "echasnovski/mini.pairs",
        event = "InsertEnter",
        config = function()
            require("mini.pairs").setup()
        end,
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
        "echasnovski/mini.indentscope",
        version = false,
        opts = {
            draw = {
                animation = function() end,
            },
        },
        config = function(_, opts)
            opts.draw.animation = require("mini.indentscope").gen_animation.none()
            require("mini.indentscope").setup(opts)
        end,
    },

    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function(_, _)
            local harpoon = require("harpoon")
            harpoon:setup()
            vim.keymap.set("n", "<leader>a", function()
                harpoon:list():add()
            end)
            vim.keymap.set("n", "<leader>m", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end)

            -- Toggle previous & next buffers stored within Harpoon list
            vim.keymap.set("n", "<CMD-[>", function()
                harpoon:list():prev()
            end)
            vim.keymap.set("n", "<CMD-]>", function()
                harpoon:list():next()
            end)
        end,
    },

    -- neo tree instead of original netrw
    {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
        branch = "v3.x",
        cmd = "Neotree",
        keys = {
            {
                "<leader>e",
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = require("au.utils").get_root() })
                end,
                desc = "Explorer NeoTree (root dir)",
            },
            {
                "<leader>E",
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
                end,
                desc = "Explorer NeoTree (cwd)",
            },
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
            default_component_configs = {
                icon = {
                    folder_closed = "+",
                    folder_open = "-",
                    folder_empty = "!",
                    folder_empty_open = "!",
                    default = "",
                    provider = function() end,
                },
                git_status = {
                    symbols = {
                        added = "",
                        deleted = "",
                        modified = "",
                        renamed = "",
                        untracked = "",
                        ignored = "",
                        unstaged = "",
                        staged = "",
                        conflict = "",
                    },
                },
            },
            filesystem = {
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
                bind_to_cwd = false,
                follow_current_file = {
                    enabled = true,
                },
                commands = {
                    -- over write default 'delete' command to 'trash'.
                    delete = function(state)
                        local inputs = require("neo-tree.ui.inputs")
                        local path = state.tree:get_node().path
                        local msg = "Are you sure you want to trash " .. path
                        inputs.confirm(msg, function(confirmed)
                            if not confirmed then
                                return
                            end

                            vim.fn.system({ "trash", vim.fn.fnameescape(path) })
                            require("neo-tree.sources.manager").refresh(state.name)
                        end)
                    end,

                    -- over write default 'delete_visual' command to 'trash' x n.
                    delete_visual = function(state, selected_nodes)
                        local inputs = require("neo-tree.ui.inputs")

                        local count = vim.tbl_count(selected_nodes)
                        local msg = "Are you sure you want to trash " .. count .. " files ?"
                        inputs.confirm(msg, function(confirmed)
                            if not confirmed then
                                return
                            end
                            for _, node in ipairs(selected_nodes) do
                                vim.fn.system({ "trash", vim.fn.fnameescape(node.path) })
                            end
                            require("neo-tree.sources.manager").refresh(state.name)
                        end)
                    end,
                },
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
