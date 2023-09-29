local M = {}

M["disable_distribution_plugins"] = function()
  -- disable some builtin vim plugins
  local plugins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "matchit",
    "tar",
    "tarPlugin",
    "rrhelper",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
    "tutor",
    "rplugin",
    "synmenu",
    "optwin",
    "compiler",
    "ftplugin",
  }

  for _, plugin in pairs(plugins) do
    vim.g["loaded_" .. plugin] = 1
  end
end

M["map_leader"] = function()
  local leader = require("cesd.core.settings").map_leader
  vim.g.mapleader = " "
  vim.api.nvim_set_keymap("n", leader, "", { noremap = true })
  vim.api.nvim_set_keymap("x", leader, "", { noremap = true })
end

M["map_H_to_vert_help"] = function()
  vim.cmd("cnoreabbrev H vert h")
end

return M
