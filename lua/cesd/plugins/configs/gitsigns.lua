local present, gitsigns = pcall(require, "gitsigns")

if present then
  gitsigns.setup()
end
