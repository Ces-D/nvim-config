local present, bufferline = pcall(require, "bufferline")

if present then
  bufferline.setup {
    options = {
      numbers = "ordinal",
      diagnostics = "nvim_lsp",
      color_icons = "true",
      seperator_style = "slant",
    }
  }
end
