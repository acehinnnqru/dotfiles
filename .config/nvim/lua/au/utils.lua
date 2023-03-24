local M = {}

local vim_opt = vim.opt
function M.set_vim_opts(opts)
    for k, v in pairs(opts) do
        vim_opt[k] = v
    end
end

return M
