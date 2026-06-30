local function is_floating(win_id)
    local config = vim.api.nvim_win_get_config(win_id)
    return config.relative ~= ""
end

local readonly_group = vim.api.nvim_create_augroup("ReadonlyProtection", { clear = true })

vim.api.nvim_create_autocmd("BufReadPost", {
    group = readonly_group,
    pattern = "*",
    callback = function()
        if is_floating(vim.api.nvim_get_current_win()) then
            return
        end

        if vim.bo.buftype ~= "" then
            return
        end

        local bufname = vim.fn.bufname()
        if bufname == "" then
            return
        end

        if vim.fn.filereadable(bufname) == 0 then
            return
        end

        local ignore_ft = { "help", "netrw", "qf", "terminal", "NvimTree" }
        if vim.tbl_contains(ignore_ft, vim.bo.filetype) then
            return
        end

        if vim.bo.readonly then
            vim.keymap.set("n", "o", "<Nop>", { buffer = true, silent = true })
            vim.keymap.set("n", "O", "<Nop>", { buffer = true, silent = true })
            vim.keymap.set("n", "i", "<Nop>", { buffer = true, silent = true })
            vim.keymap.set("n", "I", "<Nop>", { buffer = true, silent = true })
            vim.keymap.set("n", "a", "<Nop>", { buffer = true, silent = true })
            vim.keymap.set("n", "A", "<Nop>", { buffer = true, silent = true })
        end
    end,
})
