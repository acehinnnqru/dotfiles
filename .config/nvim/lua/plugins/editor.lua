return {
    {
        "ahmedkhalf/project.nvim",
        lazy = true,
    },
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        keys = {
            {"<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find file in project" },
            {"<leader>fa", "<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>", desc = "Find file in all files" },
            {"<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Find text in project" },
            {"<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find text in buffers" },
            {"<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
            {"<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
            {"<leader>fp", "<cmd>Telescope projects<cr>", desc = "Find project" },
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
            require("project_nvim")
            require("telescope").setup(opts)
            require("telescope").load_extension("projects")
        end,
    }

}
