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

require("cesd2.core.global").disable_distribution_plugins()
require("cesd2.core.options")
require("cesd2.core.keymaps")

local lazy_config = {
  defaults = {
    lazy = false,
  },
  ui = {
    border = require("cesd2.core.settings")["open_win_config"].border
  }
}

local lazy_plugins = {
  require("cesd2.plugins.coding"),
  require("cesd2.plugins.editor"),
}

require("lazy").setup(lazy_plugins, lazy_config)

require("cesd2.plugins.utils.autocommands")
