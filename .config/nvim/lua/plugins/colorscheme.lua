return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        lazy = false,
        config = function()
            require("catppuccin").setup({
                flavour = "macchiato",
                styles = {
                    comments = { "italic" },
                    conditionals = {},
                    loops = { "italic" },
                    functions = { "italic" },
                    keywords = { "italic" },
                    strings = {},
                    variables = { "italic" },
                    numbers = {},
                    booleans = { "italic" },
                    properties = { "italic" },
                    types = { "italic" },
                    operators = { "italic" },
                },
            })

            vim.cmd.colorscheme "catppuccin"
        end,
    }
}
