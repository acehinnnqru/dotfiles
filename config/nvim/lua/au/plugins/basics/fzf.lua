local find_files = function()
    require("fzf-lua").files({ cwd = require("au.utils").get_root() })
end

return {
    -- fzf-lua
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
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
                rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g '!{node_modules,.git,.direnv,go.sum}' -e ",
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
            { "<leader>/", "<cmd>FzfLua live_grep<cr>", desc = "Find text in project" },
            { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },

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
