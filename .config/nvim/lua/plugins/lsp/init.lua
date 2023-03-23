return {
	-- lsp config
	{
		"williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
		},
		opts = {
			ensure_installed = {},
		},
		config = true,
	},
    {
        "j-hui/fidget.nvim",
        event = "VeryLazy",
        priority  = 1000,
        config = function()
            require("fidget").setup({
                window = {
                    blend = 0,
                },
            })
        end,
    },
	{
		"neovim/nvim-lspconfig",
        event = "VeryLazy",
		dependencies = {
			{ "folke/neodev.nvim", event = "VeryLazy", opts = { experimental = { pathStrict = true } } },
			"mason.nvim",
			"j-hui/fidget.nvim",
		},
		opts = {
			servers = {},
			setup = {},
		},
		config = function(_, opts)
			-- setup formatting and keymaps
			require("plugins.lsp.apis").on_attach(function(client, buffer)
				if client.name == "copilot" or client.name == "null-ls" then
					return
				end
				require("plugins.lsp.format").on_attach(client, buffer)
				require("plugins.lsp.keymaps").on_attach(client, buffer)
			end)

			local servers = opts.servers
			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers) })
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

	-- lsp signiture
	{
		"ray-x/lsp_signature.nvim",
        event = { "CursorHold", "InsertEnter" },
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			-- handlers
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

			-- lsp signature configs
			local signature_config = {
				bind = true,
				handler_opts = { border = "rounded" },
			}
			require("lsp_signature").setup(signature_config)
		end,
	},

	-- cmdline tools and lsp servers
	{
		"williamboman/mason.nvim",
        event = "VeryLazy",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		opts = {
			ensure_installed = {},
		},
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			for _, tool in ipairs(opts.ensure_installed) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end,
	},

	{
		"jose-elias-alvarez/null-ls.nvim",
        event = "VeryLazy",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			sources = {},
		},
	},

	{
		"jay-babu/mason-null-ls.nvim",
        event = "VeryLazy",
		dependencies = {
			"jose-elias-alvarez/null-ls.nvim",
			"williamboman/mason.nvim",
		},
		opts = {
			automatic_setup = true,
			ensure_installed = {},
		},
	},
}
