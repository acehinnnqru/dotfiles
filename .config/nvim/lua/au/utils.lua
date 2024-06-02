local M = {}

local vim_opt = vim.opt
function M.set_vim_opts(opts)
    for k, v in pairs(opts) do
        vim_opt[k] = v
    end
end

local keymap_set = vim.keymap.set
---
-- Sets a list of keymaps using `vim.keymap.set`.
--
-- @function set_keymaps
-- @tparam { {string, string, string} | {string, string, string, table} }[] keymaps A list of keymaps to set, where each keymap is a table of the form {mode, lhs, rhs} or {mode, lhs, rhs, opts}
-- @tparam[opt] table opts Optional default options for all keymaps
-- @usage set_keymaps({{'n', '<leader>f', ':Telescope find_files<CR>'}, {'n', '<leader>g', ':Telescope live_grep<CR>'}}, {noremap=true, silent=true})
--
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

function M.set_g_opts(opts)
    local g = vim.g
    for k, v in pairs(opts) do
        g[k] = v
    end
end

M.root_patterns = { ".git" }

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
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
                if path:find(r, 1, true) then
                    roots[#roots + 1] = r
                end
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

function M.lsp_on_attach(on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, buffer)
        end,
    })
end

function M.has_words_before()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return M
