local present, treesitter = pcall(require, "nvim-treesitter.configs")

if present then
  treesitter.setup {
    ensure_installed = {
      "javascript", "typescript", "lua", "css", "html", "tsx", "python"
    },

    highlight = {
      enable = true,
      use_languagetree = true,
    },

    indent = {
      enable = true
    },

  }
end
