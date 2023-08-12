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

