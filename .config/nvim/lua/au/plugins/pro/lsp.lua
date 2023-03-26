function format()
	local buf = vim.api.nvim_get_current_buf()
	local ft = vim.bo[buf].filetype
	local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0

	vim.lsp.buf.format({
		bufnr = buf,
		filter = function(client)
			if have_nls then
				return client.name == "null-ls"
			end
			return client.name ~= "null-ls"
		end,
	})
end

local KM = {}

function KM.on_attach(client, buffer)
	local self = KM.new(client, buffer)

    -- code cmds
	self:map("<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
	self:map("<leader>cl", "LspInfo", { desc = "Lsp Info" })
	self:map("<leader>ca", "CodeActionMenu", { desc = "Code Action", mode = { "n", "v" }, has = "codeAction" })
	self:map("<leader>cf", format, { desc = "Format Document", has = "documentFormatting" })
	self:map("<leader>cf", format, { desc = "Format Range", mode = "v", has = "documentRangeFormatting" })
	self:map("<leader>cr", vim.lsp.buf.rename, { desc = "Rename", has = "rename" })
    
    -- diagnostic
	self:map("<leader>xx", vim.diagnostic.setqflist, { desc = "Telescope Diagnostics" })
	self:map("]d", KM.diagnostic_goto(true), { desc = "Next Diagnostic" })
	self:map("[d", KM.diagnostic_goto(false), { desc = "Prev Diagnostic" })
	self:map("]e", KM.diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
	self:map("[e", KM.diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
	self:map("]w", KM.diagnostic_goto(true, "WARNING"), { desc = "Next Warning" })
	self:map("[w", KM.diagnostic_goto(false, "WARNING"), { desc = "Prev Warning" })

    -- goto
	self:map("gd", "lua vim.lsp.buf.definition()", { desc = "Goto Definition" })
	self:map("gr", "lua vim.lsp.buf.references()", { desc = "References" })
	self:map("gD", "lua vim.lsp.buf.declaration()", { desc = "Goto Declaration" })
	self:map("gI", "lua vim.lsp.buf.implementation()", { desc = "Goto Implementation" })
	self:map("gT", "lua vim.lsp.buf.type_definition()", { desc = "Goto Type Definition" })

	self:map("K", vim.lsp.buf.hover, { desc = "Hover" })
	self:map("gK", vim.lsp.buf.signature_help, { desc = "Signature Help", has = "signatureHelp" })

	self:map("<leader>rl", "LspRestart", { desc = "Restart Lsp", mode = { "n" } })
end

function KM.new(client, buffer)
	return setmetatable({ client = client, buffer = buffer }, { __index = KM })
end

function KM:has(cap)
	return self.client.server_capabilities[cap .. "Provider"]
end

function KM:map(lhs, rhs, opts)
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

function KM.diagnostic_goto(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity })
	end
end

return {
    -- nvim-lspconfig: the main lsp manager
    {
		"neovim/nvim-lspconfig",
        event = "VeryLazy",
		dependencies = {
			"williamboman/mason.nvim",
            -- bridge between mason and lspconfig
			"williamboman/mason-lspconfig.nvim",
			"j-hui/fidget.nvim",
		},
		opts = {
			servers = {},
			setup = {},
		},
		config = function(_, opts)
			-- setup keymaps on attach
			require("au.utils").lsp_on_attach(function(client, buffer)
				if client.name == "copilot" or client.name == "null-ls" then
					return
				end
				KM.on_attach(client, buffer)
			end)

            -- setup servers
			local servers = opts.servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
            if require("au.utils").has_plugin("cmp_vim_lsp") then
			    local capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
            end

            -- installed all configured servers using mason
			require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers) })
            -- setup servers
			require("mason-lspconfig").setup_handlers({
				function(server)
					local server_opts = servers[server] or {}
					server_opts.capabilities = capabilities
					if opts.setup[server] then
						if opts.setup[server](server, server_opts) then
							return
						end
					elseif opts.setup["*"] then
						if opts.setup["*"](server, server_opts) then
							return
						end
					end
					require("lspconfig")[server].setup(server_opts)
				end,
			})
		end,
	},

    -- lsp server executable manager
    {
		"williamboman/mason.nvim",
        event = "VeryLazy",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
            if not opts.ensure_installed then
                return
            end
			for _, tool in ipairs(opts.ensure_installed) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end,
	},

    -- show lsp progress
    {
        "j-hui/fidget.nvim",
        event = "VeryLazy",
        opts = {
            window = {
                blend = 0,
            }
        },
        config = true,
    },

    -- code actions enhanced
    {
        "weilbith/nvim-code-action-menu",
        lazy = true,
        dependencies = { "neovim/nvim-lspconfig" },
        cmd = "CodeActionMenu",
    },

    {
        "stevearc/aerial.nvim",
        lazy = true,
        cmd = { "AerialToggle", "AerialClose", "AerialCloseAll" },
        opts = {
            on_attach = function(bufnr)
                vim.keymap.set("n", "[a", "<cmd>AerialPrev<CR>", {buffer = bufnr})
                vim.keymap.set("n", "]a", "<cmd>AerialNext<CR>", {buffer = bufnr})
            end
        },
        keys = {
            { "<leader>ta", "<cmd>AerialToggle<cr>", desc = "Toggle Aerial Window" }
        }
    }
}
