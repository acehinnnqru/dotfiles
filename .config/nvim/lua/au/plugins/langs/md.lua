return {
    {
        "lukas-reineke/headlines.nvim",
        ft = "markdown",
        config = true,
    },

    {
        "iamcco/markdown-preview.nvim",
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        config = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = "markdown",
        cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
        keys = {
            { "<leader>tp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
        },
    },

    -- modified treesitter config
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "markdown" })
            return opts
        end,
    },

    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                marksman = {},
            },
        },
    },
}
