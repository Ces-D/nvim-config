local map = vim.keymap.set

-- clear search results
map("n", "<leader>h", "<CMD>nohlsearch<CR>", { silent = true, desc = "Clear search results" })

-- move text
map("n", "<C-j>", ":m .+1<CR>==", { silent = true, desc = "Move text down" })
map("n", "<C-k>", ":m .-2<CR>==", { silent = true, desc = "Move text up" })
map("v", "<C-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move text down" })
map("v", "<C-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move text up" })

-- buffer management
map("n", "<leader>w", "<CMD>w<CR>", { silent = true, desc = "Save file" })
map("n", "<leader>bd", "<CMD>bd<CR>", { silent = true, desc = "Delete buffer" })

-- global lsp diagnostics
map("n", "<leader>f", "<CMD>lua vim.diagnostic.open_float()<CR>", { silent = true, desc = "Open floating diagnostic" })
map("n", ".e", "<CMD>lua vim.diagnostic.goto_next()<CR>", { silent = true, desc = "Go to next diagnostic" })
map("n", ",e", "<CMD>lua vim.diagnostic.goto_prev()<CR>", { silent = true, desc = "Go to previous diagnostic" })
