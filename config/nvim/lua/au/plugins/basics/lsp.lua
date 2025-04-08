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
    self:map("<leader>ca", require("actions-preview").code_actions, { desc = "Code Action", mode = { "n", "v" } })
    self:map("<leader>cf", format, { desc = "Format Document" })
    self:map("<leader>cf", format, { desc = "Format Range", mode = "v" })
    self:map("<leader>cr", "lua vim.lsp.buf.rename()", { desc = "Rename" })

    -- diagnostic
    self:map(
        "<leader>xx",
        "lua vim.diagnostic.setqflist({ severity = { min = vim.diagnostic.severity.ERROR } })",
        { desc = "View Diagnostics in quickfix" }
    )
    self:map(
        "<leader>xw",
        "lua vim.diagnostic.setqflist({ severity = { min = vim.diagnostic.severity.WARN } })",
        { desc = "View Diagnostics in quickfix" }
    )
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
    local count = next and 1 or -1
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        -- only jump to the pos, but not open float window
        local diag = vim.diagnostic.jump({
            count = count,
            severity = severity,
        })

        -- if has not diag, do nothing
        if diag == nil then
            return
        end

        -- hover here
        ---@diagnostic disable-next-line
        require("hover").hover(nil)
    end
end

return {
    -- nvim-lspconfig: the main lsp manager
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "j-hui/fidget.nvim",
            "nvimtools/none-ls.nvim",
        },
        opts = {
            servers = {},
            setup = {},
        },
        config = function(_, opts)
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client == nil then
                        return
                    end
                end,
            })
            -- setup keymaps on attach
            require("au.utils").lsp_on_attach(function(client, buffer)
                if client.name == "null-ls" then
                    return
                end
                KM.on_attach(client, buffer)
                if not client.server_capabilities.inlayHintProvider then
                    return
                else
                    vim.lsp.inlay_hint.enable(true, {
                        bufnr = buffer,
                    })
                end
            end)

            -- setup servers capabilities
            local lspconfig = require("lspconfig")
            for server, config in pairs(opts.servers) do
                -- passing config.capabilities to blink.cmp merges with the capabilities in your
                -- `opts[server].capabilities, if you've defined it
                config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
                config.capabilities.textDocument.foldingRange = {
                    dynamicRegistration = false,
                    lineFoldingOnly = true,
                }

                lspconfig[server].setup(config)
            end
        end,
    },

    -- null ls
    {
        "nvimtools/none-ls.nvim",
        event = "VeryLazy",
        opts = {
            sources = {},
        },
    },

    -- show lsp progress
    {
        "j-hui/fidget.nvim",
        event = "VeryLazy",
        opts = {
            notification = {
                window = {
                    winblend = 0,
                },
            },
        },
        config = function(_, opts)
            require("fidget").setup(opts)
        end,
    },

    -- code actions enhanced
    {
        "aznhe21/actions-preview.nvim",
        lazy = true,
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

    {
        "lewis6991/hover.nvim",
        keys = {
            {
                "K",
                function()
                    ---@diagnostic disable-next-line
                    require("hover").hover(nil)
                end,
                desc = "Hover",
            },
            {
                "gK",
                function()
                    ---@diagnostic disable-next-line
                    require("hover").hover_select(nil)
                end,
                desc = "Hover Select",
            },
        },
        opts = {
            init = function()
                -- Require providers
                require("hover.providers.lsp")
                -- require('hover.providers.gh')
                -- require('hover.providers.gh_user')
                -- require('hover.providers.jira')
                -- require('hover.providers.dap')
                -- require('hover.providers.fold_preview')
                require("hover.providers.diagnostic")
                -- require('hover.providers.man')
                -- require('hover.providers.dictionary')
            end,
            preview_opts = {
                border = "single",
            },
            -- Whether the contents of a currently open hover window should be moved
            -- to a :h preview-window when pressing the hover keymap.
            preview_window = false,
            title = true,
        },
    },
}
