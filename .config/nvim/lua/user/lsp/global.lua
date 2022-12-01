local lsp_defaults = {
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    on_attach = function(client, bufnr)
        vim.api.nvim_exec_autocmds('User', { pattern = 'LspAttached' })
    end
}

-- default global configs
Lspconfig = require('lspconfig')
Lspconfig.util.default_config = vim.tbl_deep_extend(
    'force',
    Lspconfig.util.default_config,
    lsp_defaults
)

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "sumneko_lua",
        "gopls",
        "rust_analyzer",
        "pyright",
        "tsserver",
        "cssls",
        "html",
        "jsonls",
        "marksman",
        "sqlls",
        "volar",
        "astro",
    },
})

vim.api.nvim_create_autocmd('User', {
    pattern = 'LspAttached',
    desc = 'LSP actions',

    callback = function()
        local bufmap = function(mode, lhs, rhs)
            local opts = { buffer = true }
            vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- Displays hover information about the symbol under the cursor
        bufmap('n', '<leader>h', '<cmd>lua vim.lsp.buf.hover()<cr>')
        -- Jump to the definition
        bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
        -- Jump to declaration
        bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
        -- Lists all the implementations for the symbol under the cursor
        bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
        -- Jumps to the definition of the type symbol
        bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
        -- Lists all the references
        bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
        -- Renames all references to the symbol under the cursor
        bufmap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>')
        -- Selects a code action available at the current cursor position
        bufmap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>')
        bufmap('x', '<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')
        -- Show diagnostics in a floating window
        bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
        -- Move to the previous diagnostic
        bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
        -- Move to the next diagnostic
        bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

        bufmap('n', '<leader>fm', '<cmd>lua vim.lsp.buf.format({async = true})<CR>')
        bufmap('v', '<leader>fm', '<ESC><cmd>lua vim.lsp.buf.range_formatting()<CR>')
    end
})

local null_ls = require('null-ls')

require("mason-null-ls").setup({
    ensure_installed = {
        "black",
        "isort",
        "prettier",
        "flake8",
        "misspell",
    },
    automatic_installation = true,
})

require("null-ls").setup({
    sources = {
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.diagnostics.flake8,
        null_ls.builtins.diagnostics.misspell,
    },
})

require('prettier').setup({
    bin = 'prettier',
    filetypes = {
        "css",
        "graphql",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "less",
        "markdown",
        "scss",
        "typescript",
        "typescriptreact",
        "yaml",
        "vue",
    },
})
