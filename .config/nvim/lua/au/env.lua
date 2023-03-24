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
        end
    else
        return {}
    end

    return {}
end

local basic_env = {
    environment = get_environment(),
    minimal = false,
}

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

return merge_env(basic_env, try_get_local_env("au.local_env"))
