local map = vim.keymap.set

map("", "<Space>", "<Nop>") -- disable space because leader
vim.g.mapleader=' '

-- Normal --
-- Standard Operations
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "No Highlight" })
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
map("n", "<C-s>", "<cmd>w!<cr>", { desc = "Force write" })
map("n", "<C-q>", "<cmd>q!<cr>", { desc = "Force quit" })

-- Other Helpful
map("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Unload Current Buffer" })
map("n", "L", "<cmd>bn<CR>", { desc = "Go To Next Buffer" })
map("n", "H", "<cmd>bp<CR>", { desc = "Go To Previous Buffer" })

-- Moving Text
map('n', '<C-k>', ':m .-2<CR>==')
map('n', '<C-j>', ':m .+1<CR>==')
map('v', '<C-j>', ":m '>+1<CR>gv=gv")
map('v', '<C-k>', ":m '<-2<CR>gv=gv")

-- Manage your windows like a boss
map('n', '<leader>vs', ':vsplit<CR>')
map('n', '<up>', ':resize +2<CR>')
map('n', '<down>', ':resize -2<CR>')
map('n', '<left>', ':vertical resize -2<CR>')
map('n', '<right>', ':vertical resize +2<CR>')

-- NvimTree
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle Explorer" })
map("n", "<leader>o", "<cmd>NvimTreeFocus<cr>", { desc = "Focus Explorer" })
map("n", "<leader>r", "<cmd>NvimTreeRefresh<cr>", { desc = "Refresh Explorer" })

-- LSP
map('n', '<leader>dn', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('n', '<leader>dp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n', '<leader>ds', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = "Open Float" })
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { desc = "Go to Definition" })
map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { desc = "Go to Declaration" })
map('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { desc = "Go to Type Definition" })
map("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", { desc = "Format Buffer" })

map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
map('n', 'gw', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')

-- Telescope
map("n", "<leader>gt", "<cmd>lua require('telescope.builtin').git_status()<CR>", { desc = "Git status" })
map("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<CR>", { desc = "Search files" })
map("n", "<leader>fg", "<cmd> lua require('telescope.builtin').live_grep()<CR>", { desc = "Search words" })
map("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<CR>", { desc = "Search buffers" })
map("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<CR>", { desc = "Search help" })
map("n", "<leader>sk", "<cmd>lua require('telescope.builtin').keymaps()<CR>", { desc = "Search keymaps" })
map("n", "<leader>sc", "<cmd>lua require('telescope.builtin').commands()<CR>", { desc = "Search commands" })
map("n", "<leader>lR", "<cmd>lua require('telescope.builtin').lsp_references()<CR>", { desc = "Search references" })

-- Stay in indent mode
map("v", "<", "<gv", { desc = "unindent line" })
map("v", ">", ">gv", { desc = "indent line" })

