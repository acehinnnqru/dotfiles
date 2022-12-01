require('nightfox').setup({
    options = {
        styles = { -- Style to be applied to different syntax groups
            comments = "italic", -- Value is any valid attr-list value `:help attr-list`
            conditionals = "NONE",
            constants = "NONE",
            functions = "italic",
            keywords = "bold",
            numbers = "NONE",
            operators = "NONE",
            strings = "NONE",
            types = "italic,bold",
            variables = "italic",
        },
    }
})
--[[ local colorscheme = "tokyonight" ]]
--[[]]
--[[]]
--[[ -- only for gruvbox ]]
--[[ local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme) ]]
--[[ if not status_ok then ]]
--[[     vim.notify("colorscheme " .. colorscheme .. " not found!") ]]
--[[     return ]]
--[[ end ]]

require("github-theme").setup({
    theme_style = 'dark',
    comment_style = "italic",
    keyword_style = "italic",
    function_style = "italic",
    variable_style = "italic",
    dark_sidebar = false,
    -- other config
})
