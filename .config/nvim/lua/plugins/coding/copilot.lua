return {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    opts = {
        panel = {
            enabled = false,
            auto_refresh = true,
        },
        suggestion = {
            enabled = false,
            auto_trigger = true,
        }
    },
    config = function (_, opts)
        require("copilot").setup(opts)
    end
}
