local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local branch = {
  "branch",
  icons_enabled = false,
  fmt = function(str)
    return "- ".. str .." -"
  end
}

lualine.setup({
  options = {
    icons_enabled=false,
    section_separators='',
    component_separators='',
    theme='auto'
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { branch, 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  }
})

