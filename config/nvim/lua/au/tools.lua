local tools = {}

function tools.copy_current_location()
    local path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
    local line = vim.fn.line(".")

    -- format: {path}:{line}
    local location = string.format("%s:%s", path, line)

    -- add to clipboard
    vim.fn.setreg("+", location)
end

return tools
