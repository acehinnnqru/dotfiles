return {
    {
        "ahmedkhalf/project.nvim",
        lazy = true,
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        lazy = true,
    },
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        version = false,
        keys = {
            {"n", "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find file in project" },
            {"n", "<leader>fa", "<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>", desc = "Find file in all files" },
            {"n", "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Find text in project" },
            {"n", "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find text in buffers" },
            {"n", "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
            {"n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
            {"n", "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Find project" },
            {"n", "<leader>fs", "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
        },
        opts = {
            extensions = {
                file_browser = {
                    theme = "ivy",
                    -- disables netrw and use telescope-file-browser in its place
                    hijack_netrw = true,
                },
            },
            defaults = {
                file_ignore_patterns = { "node_modules", "venv", ".git" }
            },
            pickers = {
                find_files = {
                    hidden = true
                },
                live_grep = {
                    additional_args = function(opts)
                        return { "--hidden" }
                    end
                },
            }
        },
        config = function(plugin, opts)
            require("telescope").setup(opts)
            require("telescope").load_extension("projects")
            require("telescope").load_extension("file_browser")
        end,
    }

}
