local function parse_location(query)
    local line, col
    line, col = query:match(":(%d+):(%d+)$")
    if line then return tonumber(line), tonumber(col) end
    line = query:match(":(%d+)$")
    if line then return tonumber(line), nil end
    line = query:match("#L(%d+)$")
    if line then return tonumber(line), nil end
    return nil, nil
end

local find_files = function()
    local fzf_lua = require("fzf-lua")

    fzf_lua.files({
        cwd = require("au.utils").get_root(),
        keymap = {
            fzf = {
                ["change"] = [[transform-search:echo {q} | sed -E 's/:[0-9]*:[0-9]*$//;s/:[0-9]*$//;s/#L[0-9]*$//']],
            },
        },
        actions = {
            ["default"] = function(selected, opts)
                if not selected or #selected == 0 then return end
                local query = opts.last_query or ""
                local line, col = parse_location(query)
                require("fzf-lua.actions").file_edit(selected, opts)
                if line then
                    line = math.min(line, vim.api.nvim_buf_line_count(0))
                    pcall(vim.api.nvim_win_set_cursor, 0, { line, (col or 1) - 1 })
                    vim.cmd("normal! zz")
                end
            end,
        },
    })
end

---@type [LazyPluginSpec]
return {
    -- fzf-lua
    {
        "ibhagwan/fzf-lua",
        opts = {
            winopts = {
                backdrop = 100,
            },
            fzf_opts = {},
            files = {
                rg_opts = [[--color=never --files --hidden --follow -g "!.git" -g "!node_modules" -g "!.direnv"]],
                cwd_prompt = false,
                git_icons = false,
                file_icons = false,
            },
            grep = {
                file_icons = false,
                rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g '!{node_modules,.git,.direnv,go.sum}' -e ",
            },
            keymap = {
                fzf = {
                    true,
                    ["ctrl-d"] = "preview-page-down",
                    ["ctrl-u"] = "preview-page-up",
                    ["ctrl-q"] = "select-all+accept",
                },
            },
        },
        keys = {
            { "<leader>fz", "<cmd>FzfLua builtin<cr>", desc = "FzfLua Builtin" },

            -- super cmds
            {
                "<leader><space>",
                find_files,
                desc = "Find Files (root dir)",
            },
            { "<leader>/", "<cmd>FzfLua live_grep_native<cr>", desc = "Find text in project" },
            { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },

            { "<leader>;", "<cmd>FzfLua resume<cr>", desc = "Resume Last Fzf Search" },

            -- search
            { "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Git Files" },
            { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Open Buffers" },

            { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },

            -- lsp
            {
                "<leader>fs",
                "<cmd>FzfLua lsp_document_symbols<cr>",
                desc = "Find Document Symbols",
            },
            {
                "<leader>fr",
                "<cmd>FzfLua lsp_references<cr>",
                desc = "Find Lsp References",
            },
            {
                "<leader>fi",
                "<cmd>FzfLua lsp_implementations<cr>",
                desc = "Find Lsp Implementations",
            },
        },
    },
}
