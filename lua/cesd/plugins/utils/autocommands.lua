-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = require("cesd.plugins.utils.plugin_keymaps")["lsp"],
})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.bo.filetype ~= "" then
            return
        end
        if vim.api.nvim_buf_get_lines(0, 0, -1, false)[1] == "" then
            require("telescope.builtin").find_files()
        end
    end,
})
