local M = {}

function M.on_attach(client, buffer)
	local self = M.new(client, buffer)

	self:map("<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
	self:map("<leader>cl", "LspInfo", { desc = "Lsp Info" })
	self:map("<leader>xd", "Telescope diagnostics", { desc = "Telescope Diagnostics" })
	self:map("gd", "lua vim.lsp.buf.definition()", { desc = "Goto Definition" })
	self:map("gr", "lua vim.lsp.buf.references()", { desc = "References" })
	self:map("gD", "lua vim.lsp.buf.declaration()", { desc = "Goto Declaration" })
	self:map("gI", "lua vim.lsp.buf.implementation()", { desc = "Goto Implementation" })
	self:map("gt", "lua vim.lsp.buf.type_definition()", { desc = "Goto Type Definition" })
	self:map("K", vim.lsp.buf.hover, { desc = "Hover" })
	self:map("gK", vim.lsp.buf.signature_help, { desc = "Signature Help", has = "signatureHelp" })
	self:map("]d", M.diagnostic_goto(true), { desc = "Next Diagnostic" })
	self:map("[d", M.diagnostic_goto(false), { desc = "Prev Diagnostic" })
	self:map("]e", M.diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
	self:map("[e", M.diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
	self:map("]w", M.diagnostic_goto(true, "WARNING"), { desc = "Next Warning" })
	self:map("[w", M.diagnostic_goto(false, "WARNING"), { desc = "Prev Warning" })
	self:map("<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action", mode = { "n", "v" }, has = "codeAction" })

	local format = require("plugins.lsp.format").format
	self:map("<leader>cf", format, { desc = "Format Document", has = "documentFormatting" })
	self:map("<leader>cf", format, { desc = "Format Range", mode = "v", has = "documentRangeFormatting" })
	self:map("<leader>cr", vim.lsp.buf.rename, { desc = "Rename", has = "rename" })

	self:map("<leader>rl", "LspRestart", { desc = "Restart Lsp", mode = { "n" } })
end

function M.new(client, buffer)
	return setmetatable({ client = client, buffer = buffer }, { __index = M })
end

function M:has(cap)
	return self.client.server_capabilities[cap .. "Provider"]
end

function M:map(lhs, rhs, opts)
	opts = opts or {}
	if opts.has and not self:has(opts.has) then
		return
	end
	vim.keymap.set(
		opts.mode or "n",
		lhs,
		type(rhs) == "string" and ("<cmd>%s<cr>"):format(rhs) or rhs,
		---@diagnostic disable-next-line: no-unknown
		{ silent = true, buffer = self.buffer, expr = opts.expr, desc = opts.desc }
	)
end

function M.diagnostic_goto(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity })
	end
end

return M
