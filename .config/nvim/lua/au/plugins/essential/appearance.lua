return {
    -- welcome page
    {
		"goolord/alpha-nvim",
		event = "VimEnter",
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")
            local function logo()
                local height = vim.api.nvim_win_get_height(0) / 2 - 5

                local logo = {}
                for i = 1, height do
                    table.insert(logo, "")
                end

                table.insert(logo, "hi, acehinnnqru")
                return logo
            end

			dashboard.section.header.val = logo()
			dashboard.section.buttons.val = {}

            local function footer()
				return "later equals never."
			end

			dashboard.section.footer.val = footer()
			dashboard.section.footer.opts.hl = "Comment"
			dashboard.section.header.opts.hl = "String"
			dashboard.section.buttons.opts.hl = "Keyword"

			dashboard.opts.opts.noautocmd = true

			alpha.setup(dashboard.opts)
		end,
	},

    -- color scheme
    {
        "shaunsingh/nord.nvim",
        event = "VeryLazy",
        config = function(opts)
            require("au.utils").set_g_opts(
                {
                    nord_contrast = false,
                    nord_borders = false,
                    nord_disable_background = true,
                    nord_italic = true,
                    nord_uniform_diff_background = true,
                    nord_bold = true,
                }
            )
            require('nord').set()
        end
    },

    -- status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "shaunsingh/nord.nvim" },
        event = "VeryLazy",
        opts = function()
            local theme = require("lualine.themes.nord")
            theme.normal.c.bg = nil
            local diff = {
                "diff",
                colored = true,
                always_visible = false,
            }
            local diagnostics = {
                "diagnostics",
                colored = true,
                update_in_insert = false,
                always_visible = false,
            }
            return {
                options = {
                    theme = theme,
                    globalstatus = true,
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename", diff, diagnostics },
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {},
                }
            }
        end
    }
}
