return {
    {
        "IndianBoy42/tree-sitter-just",
        ft = {
            "just",
        },
        config = function()
            require("tree-sitter-just").setup({})
        end,
        build = ":TSUpdate",
    },
    {
        "NoahTheDuke/vim-just",
        ft = {
            "just",
        },
    },
}
