local buffer = vim.api.nvim_get_current_buf()

vim.keymap.set("n", "K", "<cmd>RustLsp hover actions<cr>", { desc = "Hover Action", buffer = buffer })
vim.keymap.set("n", "<leader>cem", "<cmd>RustLsp expandMacro<cr>", { desc = "Expand Macro", buffer = buffer })
vim.keymap.set("n", "<leader>cpm", "<cmd>RustLsp parentModule<cr>", { desc = "Parent Module", buffer = buffer })
vim.keymap.set("n", "<leader>cmd", "<cmd>RustLsp moveItem up<cr>", { desc = "Move Item Down", buffer = buffer })
vim.keymap.set("n", "<leader>cmu", "<cmd>RustLsp moveItem down<cr>", { desc = "Move Item Up", buffer = buffer })
vim.keymap.set("n", "<leader>cjl", "<cmd>RustLsp joinLines<cr>", { desc = "Join Lines", buffer = buffer })
