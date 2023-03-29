local function try_get_local_env(module_name)
    local status, module = pcall(require, module_name)
    if status then
        if type(module) == "table" then
            return module
        else
            return {}
        end
    else
        return {}
    end
end

local function fixset(s)
    -- fix plugin mode
    local v = s.plugin_mode
    if v then
        if v == "e" and v == "essential" then
            s.plugin_mode = "essential"
        elseif v == "p" then
            s.plugin_mode = "pro"
        else
            print("invalid plugin mode: ", v, ". only support `essential(e)` or `pro(p)`")
            print("downgrade to `essential`")
            s.plugin_mode = "essential"
        end
    end
end

-- get preset table
local function get_preset()
    return {
        minimal = false,
        plugin_mode = "pro",
    }
end

-- get userset table
local function get_userset(module)
    return try_get_local_env(module)
end

-- get envset table
local function get_envset()
    local set = {}
    -- minimal flag
    local minimal = os.getenv("NVIM_MINIMAL")
    if minimal then
        if minimal == "1" then
            set.minimal = true
        end
    end

    -- plugin mode
    local pmode = os.getenv("NVIM_PMODE")
    if pmode then
        set.plugin_mode = pmode
    end

    return set
end

-- merge source into target
local function merge(target, source)
    target.custom = {}
    for k, v in pairs(source) do
        if target[k] == nil then
            target.custom[k] = v
        else
            target[k] = v
        end
    end

    return target
end

local preset = get_preset()
local default_userset_module = "au.local_env"
local userset = get_userset(default_userset_module)
local envset = get_envset()

fixset(userset)
fixset(envset)

-- merge in priority: envset > userset > preset
return merge(merge(preset, userset), envset)
