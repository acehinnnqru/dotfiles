local M = {}

local ns = vim.api.nvim_create_namespace("block_focus")
local augroup = vim.api.nvim_create_augroup("BlockFocus", { clear = true })
local enabled = false
local timer = vim.uv.new_timer()
local dim_hl_cache = {}

local DIM_FACTOR = 0.65

local function darken(color, factor)
    if not color then return nil end
    local b = color % 256
    local g = math.floor(color / 256) % 256
    local r = math.floor(color / 65536) % 256
    return math.floor(r * factor) * 65536 + math.floor(g * factor) * 256 + math.floor(b * factor)
end

local function get_dim_hl(hl_name)
    if dim_hl_cache[hl_name] then return dim_hl_cache[hl_name] end

    local hl = vim.api.nvim_get_hl(0, { name = hl_name, link = false })
    local dim_name = "BlockFocusDim_" .. hl_name:gsub("[%.@]", "_")

    local attrs = {}
    if hl.fg then attrs.fg = darken(hl.fg, DIM_FACTOR) end
    if hl.bold then attrs.bold = true end
    if hl.italic then attrs.italic = true end
    if hl.underline then attrs.underline = true end

    if not attrs.fg then
        local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
        attrs.fg = darken(normal.fg or 0xc0c0c0, DIM_FACTOR)
    end

    vim.api.nvim_set_hl(0, dim_name, attrs)
    dim_hl_cache[hl_name] = dim_name
    return dim_name
end

local function find_enclosing_block(node)
    while node do
        local has_brace = false
        local has_end = false
        for child in node:iter_children() do
            local t = child:type()
            if t == "{" then
                has_brace = true
                break
            end
            if t == "end" then
                has_end = true
                break
            end
        end
        if has_brace then
            return node:parent() or node
        end
        if has_end then
            return node
        end
        local nt = node:type()
        if nt == "block" or nt == "suite" then
            return node:parent() or node
        end
        node = node:parent()
    end
    return nil
end

local function update(bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

    local ok, node = pcall(vim.treesitter.get_node)
    if not ok or not node then return end

    local target = find_enclosing_block(node)
    if not target or not target:parent() then return end

    local sr, _, er, _ = target:range()
    local win_top = vim.fn.line("w0") - 1
    local win_bot = vim.fn.line("w$") - 1
    local last_line = vim.api.nvim_buf_line_count(bufnr) - 1

    -- base dim for uncaptured text (identifiers, operators without TS captures)
    if sr > 0 then
        vim.api.nvim_buf_set_extmark(bufnr, ns, 0, 0, {
            end_row = sr,
            end_col = 0,
            hl_group = "BlockFocusDimBase",
            hl_eol = true,
            priority = 150,
        })
    end
    if er < last_line then
        local last_text = vim.api.nvim_buf_get_lines(bufnr, last_line, last_line + 1, false)[1] or ""
        vim.api.nvim_buf_set_extmark(bufnr, ns, er + 1, 0, {
            end_row = last_line,
            end_col = #last_text,
            hl_group = "BlockFocusDimBase",
            hl_eol = true,
            priority = 150,
        })
    end

    -- per-capture dim: darken each syntax token individually
    local parser = vim.treesitter.get_parser(bufnr)
    if not parser then return end

    parser:for_each_tree(function(tstree, ltree)
        local query = vim.treesitter.query.get(ltree:lang(), "highlights")
        if not query then return end

        for id, capture_node in query:iter_captures(tstree:root(), bufnr, win_top, win_bot + 1) do
            local nsr, nsc, ner, nec = capture_node:range()
            if not (ner < sr or nsr > er) then goto continue end

            local dim_hl = get_dim_hl("@" .. query.captures[id])
            vim.api.nvim_buf_set_extmark(bufnr, ns, nsr, nsc, {
                end_row = ner,
                end_col = nec,
                hl_group = dim_hl,
                priority = 200,
            })

            ::continue::
        end
    end)

    -- dim LSP semantic tokens in the dimmed regions
    local function dim_lsp_range(from_row, to_row)
        local marks = vim.api.nvim_buf_get_extmarks(bufnr, -1, { from_row, 0 }, { to_row, -1 }, { details = true })
        for _, mark in ipairs(marks) do
            local _, row, col, details = mark[1], mark[2], mark[3], mark[4]
            local hl = details.hl_group
            if not hl or not hl:match("^@lsp") then goto skip end
            if not details.end_row then goto skip end

            vim.api.nvim_buf_set_extmark(bufnr, ns, row, col, {
                end_row = details.end_row,
                end_col = details.end_col,
                hl_group = get_dim_hl(hl),
                priority = 201,
            })

            ::skip::
        end
    end

    if win_top < sr then dim_lsp_range(win_top, sr - 1) end
    if win_bot > er then dim_lsp_range(er + 1, win_bot) end
end

local function setup_hl()
    dim_hl_cache = {}
    local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
    vim.api.nvim_set_hl(0, "BlockFocusDimBase", { fg = darken(normal.fg or 0xc0c0c0, DIM_FACTOR) })
end

function M.enable()
    if enabled then return end
    enabled = true
    setup_hl()

    vim.api.nvim_create_autocmd("ColorScheme", {
        group = augroup,
        callback = setup_hl,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "WinScrolled" }, {
        group = augroup,
        callback = function()
            timer:stop()
            timer:start(50, 0, vim.schedule_wrap(function()
                if not enabled then return end
                local bufnr = vim.api.nvim_get_current_buf()
                if vim.api.nvim_buf_is_valid(bufnr) then
                    update(bufnr)
                end
            end))
        end,
    })

    update(vim.api.nvim_get_current_buf())
end

function M.disable()
    if not enabled then return end
    enabled = false
    timer:stop()
    vim.api.nvim_clear_autocmds({ group = augroup })
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
        end
    end
end

function M.toggle()
    if enabled then M.disable() else M.enable() end
end

function M.is_enabled()
    return enabled
end

return M
