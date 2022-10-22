-- handlers
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = "rounded" }
)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = 'rounded' }
)

-- lsp signature configs
local signature_config = {
    bind = true,
    handler_opts = { border = 'rounded' },
}
require('lsp_signature').setup(signature_config)
