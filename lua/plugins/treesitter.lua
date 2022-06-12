local status_ok,treesitter = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
  return
end

treesitter.setup({
   highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  rainbow = {
    enable = true,
    disable = { "html" },
    extended_mode = false,
    max_file_lines = nil
  },
  autopairs = { enable = true },
  autotag = { enable = true },
  indent = { enable = false },
  incremental_selection = { enable = true },
  textobjects = { enable = true },
})
