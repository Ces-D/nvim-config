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
  vim.g.mapleader = " "
  vim.api.nvim_set_keymap("n", " ", "", { noremap = true })
  vim.api.nvim_set_keymap("x", " ", "", { noremap = true })
end

return M
