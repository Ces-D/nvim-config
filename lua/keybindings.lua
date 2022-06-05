local key_mapper = function(mode, key, result)
  vim.api.nvim_set_keymap(
    mode,
    key,
    result,
    { noremap = true, silent = true}
  )
end

-- Plugins
key_mapper('n', '<leader>tt', ':NvimTreeToggle<CR>')
key_mapper('n', '<leader>ff', ':NvimTreeFindFile<CR>')
key_mapper('n', '<leader>tr', ':NvimTreeRefresh<CR>')
