return {
    -- nvim built-in plugins
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",

    -- utils
    -- editor
    -- tranprency
    "xiyaowong/nvim-transparent",
    -- colorscheme
    'projekt0n/github-nvim-theme',
    -- bufferline
    "akinsho/bufferline.nvim",
    -- status line
    "nvim-lualine/lualine.nvim",
    -- indent tips
    "lukas-reineke/indent-blankline.nvim",
    'nmac427/guess-indent.nvim',
    -- quickfix window enhance
    { 'kevinhwang91/nvim-bqf', ft = 'qf' },
    -- welcome page
    "goolord/alpha-nvim",
    -- eazy motion
    {
        "phaazon/hop.nvim",
        branch = "v2",
    },

    -- files
    "nvim-telescope/telescope.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    "kyazdani42/nvim-web-devicons",
    -- projects
    "ahmedkhalf/project.nvim",

    -- for coding
    -- highlighting
    "nvim-treesitter/nvim-treesitter",
    'nvim-treesitter/nvim-treesitter-context',
    'norcalli/nvim-colorizer.lua',
    -- pairs
    "windwp/nvim-autopairs",
    -- commentary
    "JoosepAlviste/nvim-ts-context-commentstring",
    "numToStr/Comment.nvim",
    -- git blame
    "lewis6991/gitsigns.nvim",
    -- completion and lsp
    -- lsp
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "ray-x/lsp_signature.nvim",
    "williamboman/mason-lspconfig.nvim",
    "jayp0521/mason-null-ls.nvim",
    -- completion
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "lukas-reineke/cmp-rg",
    "hrsh7th/cmp-emoji",
    "romgrk/fzy-lua-native",
    "tzachar/fuzzy.nvim",
    "tzachar/cmp-fuzzy-buffer",
    "tzachar/cmp-fuzzy-path",
    "onsails/lspkind.nvim",
    -- snippets
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    -- formatter
    "jose-elias-alvarez/null-ls.nvim",
    "MunifTanjim/prettier.nvim",
    -- tag edit
    "kylechui/nvim-surround",
    "windwp/nvim-ts-autotag",
    -- toto comments
    "folke/todo-comments.nvim",
    -- outline
    "simrat39/symbols-outline.nvim",
    -- fold
    { 'kevinhwang91/nvim-ufo', dependencies = 'kevinhwang91/promise-async' },

    -- languages support
    -- Rust
    "simrat39/rust-tools.nvim",
}
