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


require("cesd.core.global").map_leader()
require("cesd.core.global").disable_distribution_plugins()
require("cesd.core.global").map_H_to_vert_help()
require("cesd.core.options")
require("cesd.core.keymaps")

local lazy_config = {
  defaults = {
    lazy = false,
  },
  ui = {
    border = require("cesd.core.settings")["open_win_config"].border
  }
}

local lazy_plugins = {
  require("cesd.plugins.coding"),
  require("cesd.plugins.editor"),
}

require("lazy").setup(lazy_plugins, lazy_config)

require("cesd.plugins.utils.autocommands")
-- local theme = require("cesd.core.settings").theme
