local utils = require("au.utils")

if not utils.has_command("just") then
    return {}
end

utils.install_ts({ "just" })

---@type [LazyPluginSpec]
return {
    {
        "NoahTheDuke/vim-just",
        ft = {
            "just",
        },
    },
}
