local group = vim.api.nvim_create_augroup("CustomMarkdown", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    group = group,
    callback = function()
        vim.opt_local.conceallevel = 2
        vim.opt_local.concealcursor = "nc"
    end,
})
