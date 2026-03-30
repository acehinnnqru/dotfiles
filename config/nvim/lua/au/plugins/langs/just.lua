local utils = require("au.utils")

if not utils.has_command("just") then
    return {}
end

---@type [LazyPluginSpec]
return {
    {
        "NoahTheDuke/vim-just",
        ft = {
            "just",
        },
    },
}
