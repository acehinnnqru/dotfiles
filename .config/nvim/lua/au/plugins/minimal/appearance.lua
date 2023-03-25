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
}
