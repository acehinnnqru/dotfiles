return {
    {
        "IndianBoy42/tree-sitter-just",
        config = function()
            require("tree-sitter-just").setup({})
        end,
        build = ":TSInstall",
    },
    {
        "NoahTheDuke/vim-just",
    },
}
