return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "BufReadPost",
        opts = {
            ensure_installed = {
                -- config filetypes
                "json", "markdown", "yaml", "toml",
                "gitignore",

                -- script languages
                "bash", "python", "vim", "sql",

                -- web related
                "javascript", "html", "css", "typescript", "vue", "tsx",

                -- other languages
                "rust",
                "go", "gomod",

                -- org filetypes
                "markdown", "markdown_inline",

                -- other
                "comment", "regex",
                "help",
            },
            sync_install = false,
            highlight = {
                enable = true,
            },
            indent = {
                enable = true
            },
            incremental_selection = {
                enable = true
            },
            context_commentstring = {
                enable = true,
            }
        },

        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    }
}
