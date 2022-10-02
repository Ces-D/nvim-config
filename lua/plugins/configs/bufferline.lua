local present, bufferline = pcall(require, "bufferline")

if not present then
  return
end

bufferline.setup {
    options = {
      numbers = "ordinal",
      diagnostics = "nvim_lsp",
      color_icons = "true",
      seperator_style = "slant",
    }
  }