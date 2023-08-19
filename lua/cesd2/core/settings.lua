local settings = {}

settings["map_leader"] = " "

-- see `:h nvim_open_win()`
settings["open_win_config"] = {
  style = "minimal",
  border = "rounded"
}

-- see `https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/server_configurations`
settings["mason_lspconfig_servers"] = {
  "bashls",
  "html",
  "cssls",
  "cssmodules_ls",
  "jsonls",
  "lua_ls",
  "pyright",
  "tsserver",
  "rust_analyzer",
  "docker_ls",
  "marksman"
}

settings["treesitter_servers"] = {
  "bash", "html", "javascript", "json", "lua",
  "markdown", "markdown_inline", "python", "tsx",
  "typescript", "vim", "yaml", "lua", "css",
  "html", "rust", "dockerfile", "toml"
}

settings["copilot_filetypes"] = {
  markdown = true,
  typescript = true,
  typescriptreact = true,
  rust = true,
  python = true,
  ["*"] = false
}

settings["telescope_ignore_patterns"] = {
  ".git/", "target/", "docs/", "vendor/*", "%.lock", "__pycache__/*", "%.sqlite3", "%.ipynb", "node_modules/*",
  -- "%.jpg", "%.jpeg", "%.png", "%.svg", "%.otf", "%.ttf",
  "%.webp", ".dart_tool/", ".github/", ".gradle/", ".idea/", ".settings/", ".vscode/", "__pycache__/",
  "build/", "gradle/", "node_modules/", "%.pdb", "%.dll", "%.class", "%.exe", "%.cache", "%.ico", "%.pdf",
  "%.dylib", "%.jar", "%.docx", "%.met", "smalljre_*/*", ".vale/", "%.burp", "%.mp4", "%.mkv", "%.rar",
  "%.zip", "%.7z", "%.tar", "%.bz2", "%.epub", "%.flac", "%.tar.gz",

}

return settings
