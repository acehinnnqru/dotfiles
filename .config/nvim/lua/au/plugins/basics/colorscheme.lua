return {
    {
        "EdenEast/nightfox.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            options = {
                dim_inactive = false,
                transparent = true,
                styles = {
                    comments = "italic",
                    conditionals = "NONE",
                    constants = "NONE",
                    functions = "italic",
                    keywords = "italic",
                    numbers = "NONE",
                    operators = "NONE",
                    strings = "NONE",
                    types = "italic,bold",
                    variables = "NONE",
                },
            },
        },
        config = function(_, opts)
            require("nightfox").setup(opts)
            vim.cmd("colorscheme nordfox")
        end,
    },
    {
        "xiyaowong/transparent.nvim",
        lazy = false,
        priority = 999,
        opts = {
            extra_groups = {
                "NeoTreeFloatNormal",
                "NormalFloat",
                "LspFloatWinNormal",
                "FloatShadow",
                "FloatShadowThrough",
                "DiagnosticFloatingInfo",
                "DiagnosticFloatingError",
                "DiagnosticFloatingWarn",
                "DiagnosticFloatingHint",
                "DiagnosticFloatingOk",
            },
        },
        config = function(opts)
            require("transparent").setup(opts)
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", fg = 13487823 })
        end,
    },
}
