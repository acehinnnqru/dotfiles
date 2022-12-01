require 'user.lsp.global'
require 'user.lsp.lsp-signature'

-- lua
Lspconfig.sumneko_lua.setup(require('user.lsp.langs.sumneko_lua'))
Lspconfig.gopls.setup(require('user.lsp.langs.gopls'))
Lspconfig.rust_analyzer.setup(require('user.lsp.langs.rust-analyzer'))
Lspconfig.pyright.setup(require('user.lsp.langs.pyright'))
Lspconfig.tsserver.setup(require('user.lsp.langs.tsserver'))
Lspconfig.cssls.setup({})
Lspconfig.html.setup({})
Lspconfig.jsonls.setup({})
Lspconfig.marksman.setup({})
Lspconfig.sqlls.setup({})
Lspconfig.volar.setup(require('user.lsp.langs.volar'))
Lspconfig.astro.setup({})
