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

return M
