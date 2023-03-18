return {
    "zbirenbaum/copilot-cmp",
    dependencies = {
        "zbirenbaum/copilot.lua",
    },
    config = function (_, opts)
        require("copilot_cmp").setup(opts)
    end
}
