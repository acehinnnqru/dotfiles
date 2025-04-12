local utils = require("au.utils")

---@type [LazyPluginSpec]
return {
    {
        "EdenEast/nightfox.nvim",
        priority = 1000,
        opts = {
            options = {
                transparent = true,
            },
        },
        config = function(_, opts)
            require("nightfox").setup(opts)
            utils.set_colorscheme("nightfox")
        end,
    },
}
