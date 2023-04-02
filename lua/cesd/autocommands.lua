local api = vim.api

-- this autocommand sucks
api.nvim_create_autocmd("BufWritePost", {
  command = "echo strftime('%c')"
})
