local function get_environment()
    if vim.fn.exists('g:vscode') == 1 then
        return 'vscode'
    elseif vim.fn.exists('gui_running') == 1 then
        return 'gui'
    else
        return 'nvim'
    end
end

local function try_get_local_env(module_name)
    local status, module = pcall(require, module_name)
    if status then
        if type(module) == 'table' then
            return module
        else
            return {}
        end
    else
        return {}
    end
end

--- Check if an environment variable is set to 1
--- @param var_name string: the name of the environment variable
--- @return boolean: true if the environment variable is set to 1, false otherwise
local function check_env_var(var_name)
  local var_value = os.getenv(var_name)
  return var_value and var_value == "1"
end

local function merge_env(source, local_env)
    source.custom = {}
    -- set all the keys into `source` table
    for k, v in pairs(local_env) do
        if source[k] == nil then
            source.custom[k] = v
        else
            source[k] = v
        end
    end

    return source
end


-- preset is the default envs
local preset_env = {
    environment = get_environment(),
    minimal = false,
}

-- user local set variable gets the second priority
local user_env = merge_env(preset_env, try_get_local_env("au.local_env"))

-- env variable gets the highest priority
user_env.minimal = check_env_var("NVIM_MINIMAL")

return user_env
