local utils = require("au.utils")

return {
    {
        "EdenEast/nightfox.nvim",
        priority = 1000,
        opts = {},
        config = function(_, opts)
            require("nightfox").setup(opts)
            utils.set_colorscheme("nordfox")
        end,
    },
}
