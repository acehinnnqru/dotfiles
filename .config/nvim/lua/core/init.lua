-- bootstrap
require("core.bootstrap")

-- load init options
require("core.init-options")

-- setup lazy
local lazy_spec = require("core.lazy-spec")
local lazy_opts = require("core.lazy-options")
require("lazy").setup(lazy_spec, lazy_opts)
