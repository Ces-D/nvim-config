local status_ok, treesitter = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
  return
end

treesitter.setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  },
  autopairs = { enable = true },
  autotag = { enable = true },
  indent = { enable = true, disable = {} },
  incremental_selection = { enable = true },
  textobjects = { enable = true },
})
