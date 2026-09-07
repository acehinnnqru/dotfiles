---@type LazyPluginSpec[]
return {
    {
        dir = ".",
        event = "VeryLazy",
        config = function()
            require("au.lab.block-focus").enable()
        end,
        keys = {
            {
                "<leader>bf",
                function()
                    require("au.lab.block-focus").toggle()
                end,
                desc = "Toggle block focus",
            },
        },
    },
}
