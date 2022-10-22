local fn = vim.fn

-- install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git", "clone", "--depth", "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen NeoVim..."
    vim.cmd [[packadd packer.nvim]]
end

-- autocommand that reloads NeoVim whenever you save the plugins.lua file
vim.cmd [[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]]

local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- set packer to use a popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

-- install plugins here
return packer.startup(function(use)
    -- packer itself
    use "wbthomason/packer.nvim"

    -- nvim built-in plugins
    use "nvim-lua/popup.nvim"
    use "nvim-lua/plenary.nvim"

    -- utils
    use "lewis6991/impatient.nvim"

    -- editor
    -- tranprency
    use "xiyaowong/nvim-transparent"
    -- colorscheme
    use "EdenEast/nightfox.nvim"
    use 'folke/tokyonight.nvim'
    -- bufferline
    use "akinsho/bufferline.nvim"
    -- status line
    use "nvim-lualine/lualine.nvim"
    -- indent tips
    use "lukas-reineke/indent-blankline.nvim"
    -- welcome page
    use "goolord/alpha-nvim"
    -- eazy motion
    use {
        "phaazon/hop.nvim",
        branch = "v2",
    }

    -- files
    use "nvim-telescope/telescope.nvim"
    use "nvim-telescope/telescope-file-browser.nvim"
    use "kyazdani42/nvim-web-devicons"
    --[[ use "kyazdani42/nvim-tree.lua" ]]
    -- projects
    use "ahmedkhalf/project.nvim"

    -- for coding
    -- highlighting
    use "nvim-treesitter/nvim-treesitter"
    use 'nvim-treesitter/nvim-treesitter-context'
    -- pairs
    use "windwp/nvim-autopairs"
    -- commentary
    use "JoosepAlviste/nvim-ts-context-commentstring"
    use "numToStr/Comment.nvim"
    -- git blame
    use "lewis6991/gitsigns.nvim"
    -- completion and lsp
    -- lsp
    use "neovim/nvim-lspconfig"
    use "ray-x/lsp_signature.nvim"
    use "williamboman/nvim-lsp-installer"
    -- completion
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-nvim-lsp-signature-help"
    use "lukas-reineke/cmp-rg"
    use "hrsh7th/cmp-emoji"
    use "romgrk/fzy-lua-native"
    use "tzachar/fuzzy.nvim"
    use "tzachar/cmp-fuzzy-buffer"
    use "tzachar/cmp-fuzzy-path"
    use "onsails/lspkind.nvim"
    -- snippets
    use "saadparwaiz1/cmp_luasnip"
    use "L3MON4D3/LuaSnip"
    use "rafamadriz/friendly-snippets"
    -- formatter
    use "jose-elias-alvarez/null-ls.nvim"
    use "MunifTanjim/prettier.nvim"
    -- tag edit
    use "kylechui/nvim-surround"
    -- toto comments
    use "folke/todo-comments.nvim"

    -- languages support
    -- Rust
    use "simrat39/rust-tools.nvim"

    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
