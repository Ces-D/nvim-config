local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- latest stable release lazypath,
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable" })
end
vim.opt.rtp:prepend(lazypath)

require("cesd.options")
require("lazy").setup("cesd.plugins")
local utils = require("cesd.utils")

for _, setup_plugin in pairs(require("cesd.setups")) do
  setup_plugin()
end

for _, mapping in pairs(require("cesd.mappings")) do
  utils.load_mappings(mapping)
end
