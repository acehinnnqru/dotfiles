local utils = require("au.utils")
local set_g = utils.set_g_opts

return {
    -- color scheme
    {
        "shaunsingh/nord.nvim",
        lazy = true,
        event = "UiEnter",
        config = function(opts)
            set_g(
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

    -- dev icons
    {
		"kyazdani42/nvim-web-devicons",
        lazy = true,
        event = "UiEnter",
		opts = {
			default = true,
		},
	},
}
