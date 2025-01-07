local tools = require("au.tools")

return {
    -- better up/down
    { "n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true } },
    { "n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true } },

    -- as we have set the clipboard to system clipboard,
    --     but it is so annoying when x/X/<Del> will access the clipboard too.
    { "n", "x", '"_x', { noremap = true } },
    { "n", "X", '"_X', { noremap = true } },

    -- window navigation
    { "n", "<C-h>", "<C-w>h", { desc = "Go to left window" } },
    { "n", "<C-j>", "<C-w>j", { desc = "Go to lower window" } },
    { "n", "<C-k>", "<C-w>k", { desc = "Go to upper window" } },
    { "n", "<C-l>", "<C-w>l", { desc = "Go to right window" } },

    -- window management
    { "n", "<leader>wd", "<C-W>c", { desc = "delete-window" } },
    { "n", "<leader>wj", "<C-W>s", { desc = "split-window-below" } },
    { "n", "<leader>wl", "<C-W>v", { desc = "split-window-right" } },

    -- buffers navigation
    { "n", "<leader>bd", "<cmd>:bdelete<cr>", { desc = "Delete Buffer" } },
    { "n", "<leader>b]", "<cmd>:BufferLineCycleNext<CR>", { desc = "Next Buffer" } },
    { "n", "<leader>bb", "<cmd>:e #<cr>", { desc = "Switch to Other Buffer" } },
    { "n", "<leader>b[", "<cmd>:BufferLineCyclePrev<CR>", { desc = "Previous Buffer" } },

    -- clear search with <esc>
    { { "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" } },

    -- clear search and redraw
    { "n", "<leader>rd", "<cmd>noh<cr><cmd>redraw<cr><c-l>", { desc = "Redraw and clear hlsearch" } },

    -- change the behavior of search
    -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
    { { "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" } },
    { { "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" } },

    -- better indenting
    { "v", "<", "<gv" },
    { "v", ">", ">gv" },

    -- quit
    { "n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" } },

    -- tools
    { "n", "<leader>tl", tools.copy_current_location, { desc = "Copy Current Location" } },
}
