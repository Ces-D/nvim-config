local M = {}

M.load_mappings = function(mapping_opts)
  for mode, mode_mappings in pairs(mapping_opts) do
    for keybind, mapping_value in pairs(mode_mappings) do
      vim.keymap.set(mode, keybind, mapping_value[1], { desc = mapping_value[2] })
    end
  end
end

M.determine_OS = function()
  if package.config:sub(1, 1) == "\\"
  then return "Windows"
  else return "Unix"
  end
end

return M
