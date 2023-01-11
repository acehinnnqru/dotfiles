-- bootstrap
require("core.bootstrap")

-- load init options
require("core.init-options")

-- setup lazy
local lazy_opts = require("core.lazy-options")
require("lazy").setup("plugins", lazy_opts)
