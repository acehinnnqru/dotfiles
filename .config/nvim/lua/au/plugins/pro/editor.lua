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
        tag = "v2.0.1",
        lazy = false,
        init = function()
            vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
        end,
        opts = {
            log_level = "error",
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
    -- keywords: TODO/FIXME/PERF/NOTE/TEST
    -- usage: using `{keyword}: {text}`
    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        cmd = { "TodoQuickFix", "TodoTelescope" },
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
            { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Todo Telescope" },
        },
        config = true,
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
                    { { "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "GitSigns Select Hunk" } },
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
        lazy = true,
        keys = { "<leader>" },
        opts = {
            plugins = { spelling = true },
            key_labels = { ["<leader>"] = "SPC" },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.register({
                mode = { "n", "v" },
                ["]"] = { name = "+next" },
                ["["] = { name = "+prev" },
                ["<leader>b"] = { name = "+buffer" },
                ["<leader>c"] = { name = "+code" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>gh"] = { name = "+hunk" },
                ["<leader>h"] = { name = "+help" },
                ["<leader>j"] = { name = "+jump" },
                ["<leader>q"] = { name = "+quit/session" },
                ["<leader>r"] = { name = "+restart/reload" },
                ["<leader>s"] = { name = "+search" },
                ["<leader>sd"] = { name = "+debug" },
                ["<leader>t"] = { name = "+toggle" },
                ["<leader>x"] = { name = "+quickfix" },
                ["<leader>w"] = { name = "+windows" },
                ["<leader>d"] = { name = "+debug" },
                ["<leader>dv"] = { name = "+views" },
            })
        end,
    },

    -- better quickfix window
    {
        "kevinhwang91/nvim-bqf",
        ft = { "qf" },
    },
}
