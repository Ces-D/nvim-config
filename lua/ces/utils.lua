local M = {}

-- Function that lets us more easily define mappings specific for LSP related items. It sets the mode, buffer and description for us each time.
function M.map(keys, func, desc, mode, noremap)
    mode = mode or "n"
    vim.keymap.set(mode, keys, func, { desc = desc, silent = true, noremap = noremap or true })
end

return M
