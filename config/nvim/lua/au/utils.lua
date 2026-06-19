local M = {}

local vim_opt = vim.o
---@param opts table
function M.set_vim_opts(opts)
    for k, v in pairs(opts) do
        vim_opt[k] = v
    end
end

local keymap_set = vim.keymap.set

--- Sets a list of keymaps using `vim.keymap.set`.
---
---@param keymaps {[1]: string|table, [2]: string, [3]: string|function, [4]: table?}[]
---@param opts any
function M.set_keymaps(keymaps, opts)
    for _, map in ipairs(keymaps) do
        local mode, lhs, rhs, options
        if #map == 3 then
            mode, lhs, rhs = unpack(map)
        elseif #map == 4 then
            mode, lhs, rhs, options = unpack(map)
        else
            error("Invalid keymap: " .. vim.inspect(map))
        end
        keymap_set(mode, lhs, rhs, vim.tbl_extend("force", options or {}, opts or {}))
    end
end

M.root_patterns = { ".envrc", ".direnv", ".git" }

--- returns the root directory based on:
--- * lsp workspace folders
--- * lsp root_dir
--- * root pattern of filename of the current buffer
--- * root pattern of cwd
---@return string
function M.get_root()
    ---@type string?
    local path = vim.api.nvim_buf_get_name(0)
    path = path ~= "" and vim.loop.fs_realpath(path) or nil
    ---@type string[]
    local roots = {}
    if path then
        for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
            local workspace = client.config.workspace_folders
            local paths = workspace
                    and vim.tbl_map(function(ws)
                        return vim.uri_to_fname(ws.uri)
                    end, workspace)
                or client.config.root_dir and { client.config.root_dir }
                or {}
            for _, p in ipairs(paths) do
                local r = vim.loop.fs_realpath(p)
                if r == nil then
                    goto continue
                end

                if path:find(r, 1, true) then
                    roots[#roots + 1] = r
                end

                ::continue::
            end
        end
    end
    -- sort by length
    table.sort(roots, function(a, b)
        return #a > #b
    end)
    ---@type string?
    local root = roots[1]
    if not root then
        path = path and vim.fs.dirname(path) or vim.loop.cwd()
        ---@type string?
        root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
        root = root and vim.fs.dirname(root) or vim.loop.cwd()
    end
    ---@cast root string
    return root
end

---@param on_attach fun(client: vim.lsp.Client?, bufnr: integer)
function M.lsp_on_attach(on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, bufnr)
        end,
    })
end

---@param command string The command the check if exists
---@param lsp string The lsp to enable if the command exists
function M.enable_or_ignore_lsp(command, lsp)
    if not M.has_command(command) then
        return
    end

    vim.lsp.enable(lsp)
end

---@param commands string[] The commands to check
---@return boolean
function M.has_any_command(commands)
    for _, command in ipairs(commands) do
        if M.has_command(command) then
            return true
        end
    end

    return false
end

---@param command string The command to check
---@return boolean
function M.has_command(command)
    local sys_command = "which " .. command
    local handle = io.popen(sys_command)
    if handle == nil then
        return false
    end
    local result = handle:read("*a")
    handle:close()
    return result ~= ""
end

---@param theme string
function M.set_colorscheme(theme)
    vim.cmd("colorscheme " .. theme)

    -- make some hls' guibg empty
    local groups = {
        -- neo-tree
        "NeoTreeNormal",
        "NeoTreeFloatNormal",
        "NeoTreeWinSeparator",

        "NormalFloat",
        "LspFloatWinNormal",
        "LspInlayHint",
        "FloatShadow",
        "FloatShadowThrough",
        "StatusLine",

        -- diagnostics
        "DiagnosticFloatingInfo",
        "DiagnosticFloatingError",
        "DiagnosticFloatingWarn",
        "DiagnosticFloatingHint",
        "DiagnosticFloatingOk",
    }

    for _, group in pairs(groups) do
        local cmd = string.format("hi %s guibg=NONE", group)
        vim.cmd(cmd)
    end
end

---@return string
---@return boolean
function M.if_enable_ts(filetype)
    local ts = require("nvim-treesitter")
    local lang = vim.treesitter.language.get_lang(filetype)
    local installed = ts.get_installed()

    if lang ~= nil and installed[lang] then
        return lang, true
    end

    return "", false
end

---@param langs string[]
function M.install_ts(langs)
    local ts = require("nvim-treesitter")
    local installed = ts.get_installed()
    for _, lang in ipairs(langs) do
        if not installed[lang] then
            ts.install(lang)
        end
    end
end

return M
