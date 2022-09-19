local M = {}

M.load_mappings = function(mapping_opts)
  local map = vim.keymap.set

  for mode, mode_mappings in pairs(mapping_opts) do
    for m, m_value in pairs(mode_mappings) do 
      map(mode, m, m_value[1], { desc = m_value[2] })
    end
  end
end

return M
