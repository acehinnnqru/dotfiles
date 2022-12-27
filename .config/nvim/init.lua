-- boostrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.runtimepath:prepend(lazypath)

-- load lazy.nvim
require("lazy").setup("plugins")

require "user.options"
require "user.plugins"
require "user.keymaps"
require "user.colorscheme"
require "user.plugins-config"
require "user.lsp"
