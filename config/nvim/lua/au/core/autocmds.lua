vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        if vim.bo.readonly then
            vim.bo.modifiable = false
        end
    end,
})
