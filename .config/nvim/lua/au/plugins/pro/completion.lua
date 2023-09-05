return {
    -- nvim-cmp: the main completion plugin
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "f3fora/cmp-spell",
            "hrsh7th/cmp-cmdline",
        },
        opts = function()
            local cmp = require("cmp")
            local utils = require("au.utils")

            -- autopairs setup
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

            -- command line completion
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })

            return {
                completion = {},
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        local luasnip = require("luasnip")
                        if require("copilot.suggestion").is_visible() then
                            require("copilot.suggestion").accept()
                        elseif cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        elseif utils.has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        local luasnip = require("luasnip")
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "lsp_signature" },
                    { name = "luasnip" },
                }, {
                    { name = "nvim_lsp_signature_help" },
                }, {
                    { name = "path" },
                    { name = "buffer" },
                }),
                formatting = {
                    format = function(entry, item)
                        item.kind = string.format("(%s)", item.kind)
                        item.menu = ({
                            nvim_lsp = "[LSP]",
                            spell = "[Spellings]",
                            buffer = "[Buffer]",
                            luasnip = "[Snip]",
                            path = "[Path]",
                            nvim_lsp_signature_help = "[Signature]",
                            lsp_signature = "[Signature]",
                            cmdline = "[Vim Command]",
                        })[entry.source.name]
                        return item
                    end,
                },
            }
        end,
    },

    -- lua snip
    {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",
        dependencies = {
            {
                "rafamadriz/friendly-snippets",
                config = function(_, _)
                    require("luasnip.loaders.from_vscode").lazy_load()
                end,
            },
        },
        opts = {
            history = true,
            delete_check_events = "TextChanged",
        },
    },

    -- copilot support
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        cmd = "Copilot",
        opts = {
            panel = {
                auto_refresh = true,
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                keymap = {
                    accept = "<M-i>",
                    accept_word = "<M-w>",
                    accept_line = "<M-l>",
                },
            },
        },
        config = function(_, opts)
            require("copilot").setup(opts)
        end,
        keys = {
            {
                "<leader>ts",
                function()
                    require("copilot.suggestion").toggle_auto_trigger()
                end,
                desc = "Toggle Copilot Suggestion",
            },
        },
    },
}
