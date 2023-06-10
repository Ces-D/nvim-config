local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("cesd.options")
require("lazy").setup({
  spec = require("cesd.plugins"),
  defaults = {
    lazy    = true,
    version = "*"
  },
  ui = {
    border = "solid"
  }
}
)

local utils = require("cesd.utils")

for _, mapping in pairs(require("cesd.mappings")) do
  utils.load_mappings(mapping)
end
