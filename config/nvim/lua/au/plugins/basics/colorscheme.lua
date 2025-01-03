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

            -- make guibg empty
            local groups = {
                "NeoTreeFloatNormal",
                "NormalFloat",
                "LspFloatWinNormal",
                "LspInlayHint",
                "FloatShadow",
                "FloatShadowThrough",
                "DiagnosticFloatingInfo",
                "DiagnosticFloatingError",
                "DiagnosticFloatingWarn",
                "DiagnosticFloatingHint",
                "DiagnosticFloatingOk",
                "StatusLine",
            }

            for _, group in pairs(groups) do
                local cmd = string.format("hi %s guibg=NONE", group)
                vim.cmd(cmd)
            end
        end,
    },
}
