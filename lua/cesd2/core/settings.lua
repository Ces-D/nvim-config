local settings = {}

-- see `:h nvim_open_win()`
settings["open_win_config"] = {
  style = "minimal",
  border = "rounded"
}

-- see `https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/server_configurations`
settings["lsp_deps"] = {
  "bashls",
  "html",
  "cssls",
  "cssmodules_ls",
  "jsonls",
  "lua_ls",
  "pyright",
  "tsserver",
  "rust_analyzer",
  "dockerls",
  "marksman"
}

settings["copilot_filetypes"] = {
  markdown = true,
  typescript = true,
  rust = true,
  python = true,
  ["*"] = false
}

return settings
