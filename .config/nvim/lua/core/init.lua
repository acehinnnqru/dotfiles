-- bootstrap
require("core.bootstrap")

-- load init options
require("core.init-options")

-- setup lazy
local specs = {
    spec = {
        { import = "plugins" },
        { import = "plugins.extras.languages.lua" },
    },
}
local lazy_opts = require("core.lazy-options")
require("lazy").setup(specs, lazy_opts)
