local function format()
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
    self:map("<leader>cd", "lua vim.diagnostic.open_float()", { desc = "Line Diagnostics" })
    self:map("<leader>cl", "LspInfo", { desc = "Lsp Info" })
    self:map("<leader>ca", "CodeActionMenu", { desc = "Code Action", mode = { "n", "v" } })
    self:map("<leader>cf", format, { desc = "Format Document" })
    self:map("<leader>cf", format, { desc = "Format Range", mode = "v" })
    self:map("<leader>cr", "lua vim.lsp.buf.rename()", { desc = "Rename" })

    -- diagnostic
    self:map("<leader>xx", "lua vim.diagnostic.setqflist()", { desc = "View Diagnostics in quickfix" })
    self:map("]d", KM.diagnostic_goto(true), { desc = "Next Diagnostic" })
    self:map("[d", KM.diagnostic_goto(false), { desc = "Prev Diagnostic" })
    self:map("]e", KM.diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
    self:map("[e", KM.diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
    self:map("]w", KM.diagnostic_goto(true, "WARNING"), { desc = "Next Warning" })
    self:map("[w", KM.diagnostic_goto(false, "WARNING"), { desc = "Prev Warning" })

    -- goto
    self:map("gd", KM.definition_goto(), { desc = "Goto Definition" })
    self:map("gr", "lua vim.lsp.buf.references()", { desc = "References" })
    self:map("gD", "lua vim.lsp.buf.declaration()", { desc = "Goto Declaration" })
    self:map("gI", "lua vim.lsp.buf.implementation()", { desc = "Goto Implementation" })
    self:map("gT", "lua vim.lsp.buf.type_definition()", { desc = "Goto Type Definition" })

    self:map("K", "lua vim.lsp.buf.hover()", { desc = "Hover" })
    self:map("gK", "lua vim.lsp.buf.signature_help()", { desc = "Signature Help" })

    self:map("<leader>rl", "LspRestart", { desc = "Restart Lsp", mode = { "n" } })
end

function KM.new(client, buffer)
    return setmetatable({ client = client, buffer = buffer }, { __index = KM })
end

function KM:map(lhs, rhs, opts)
    opts = opts or {}
    vim.keymap.set(
        opts.mode or "n",
        lhs,
        type(rhs) == "string" and ("<cmd>%s<cr>"):format(rhs) or rhs,
        ---@diagnostic disable-next-line: no-unknown
        { silent = true, buffer = self.buffer, expr = opts.expr, desc = opts.desc }
    )
end

function KM.definition_goto()
    local function on_list(options)
        vim.fn.setqflist({}, " ", options)
        vim.api.nvim_command("cfirst")
    end
    return function()
        vim.lsp.buf.definition({ on_list = on_list })
    end
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
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            -- bridge between mason and lspconfig
            "williamboman/mason-lspconfig.nvim",
            "j-hui/fidget.nvim",
            "jose-elias-alvarez/null-ls.nvim",
            "nvimtools/none-ls.nvim",
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
                if not client.server_capabilities.inlayHintProvider then
                    return
                else
                    vim.lsp.inlay_hint(buffer)
                end
            end)

            -- setup servers
            local servers = opts.servers
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            }

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
        opts = {
            ensure_installed = {},
        },
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

    {
        "williamboman/mason-lspconfig.nvim",
        lazy = true,
        opts = {
            ensure_installed = {},
        },
        config = true,
    },

    -- null ls
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = "VeryLazy",
        opts = {
            sources = {},
        },
    },

    {
        "nvimtools/none-ls.nvim",
        event = "VeryLazy",
        dependencies = {
            "jose-elias-alvarez/null-ls.nvim",
            "williamboman/mason.nvim",
        },
        opts = {
            ensure_installed = {},
        },
    },

    -- show lsp progress
    {
        "j-hui/fidget.nvim",
        event = "VeryLazy",
        opts = {
            window = {
                blend = 0,
            },
        },
        config = function(_, opts)
            vim.cmd("highlight! FidgetTask guifg=#616e99")
            require("fidget").setup(opts)
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

    -- code actions enhanced
    {
        "weilbith/nvim-code-action-menu",
        lazy = true,
        dependencies = { "neovim/nvim-lspconfig" },
        cmd = "CodeActionMenu",
    },

    {
        "stevearc/aerial.nvim",
        dependencies = { "neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter" },
        lazy = true,
        cmd = { "AerialToggle", "AerialClose", "AerialCloseAll" },
        opts = {
            on_attach = function(bufnr)
                vim.keymap.set("n", "[a", "<cmd>AerialPrev<CR>", { buffer = bufnr })
                vim.keymap.set("n", "]a", "<cmd>AerialNext<CR>", { buffer = bufnr })
            end,
        },
        keys = {
            { "<leader>co", "<cmd>AerialToggle<cr>", desc = "Toggle Aerial(Code Outline) Window " },
        },
    },
}
