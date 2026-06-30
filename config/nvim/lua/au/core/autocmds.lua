vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        local bufname = vim.fn.bufname()
        if bufname == "" then
            return
        end
        if vim.bo.buftype ~= "" then
            return
        end
        if vim.bo.filetype == "fzf" then
            return
        end
        if vim.fn.filereadable(bufname) == 0 then
            return
        end

        if vim.bo.readonly then
            vim.keymap.set("n", "o", "<Nop>", { buffer = true })
            vim.keymap.set("n", "i", "<Nop>", { buffer = true })
            vim.keymap.set("n", "a", "<Nop>", { buffer = true })
        end
    end,
})
