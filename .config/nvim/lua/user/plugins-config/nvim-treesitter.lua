require 'nvim-treesitter.configs'.setup {
    -- install features
    ensure_installed = {
        "comment",
        "bash",
        "cmake", "cpp", "llvm", "make",
        "gitignore",
        "go", "gomod",
        "graphql",
        "help",
        "javascript", "html", "css", "typescript",
        "sql",
        "rust",
        "python",
        "lua",
        "vim",
        "vue",
        "regex",
        "json", "markdown", "yaml", "toml",
        "help",
        "org",
    },
    sync_install = true,
    auto_install = true,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = {"org"},
    },
    indent = {
        enable = true
    },
    incremental_selection = {
        enable = true
    },
    context_commentstring = {
        enable = true,
    }
}

require 'nvim-treesitter'.setup{}

