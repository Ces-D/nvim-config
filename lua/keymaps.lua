local nnoremap = function(keymap, handler, opts)
    vim.keymap.set("n", keymap, handler, opts)
end

local vnoremap = function(keymap, handler, opts)
    vim.keymap.set("v", keymap, handler, opts)
end

local inoremap = function(keymap, handler, opts)
    vim.keymap.set("i", keymap, handler, opts)
end

-- Normal --
-- Disable Space bar since it'll be used as the leader key
nnoremap("<space>", "<nop>")

-- Save with leader key
nnoremap("<leader>w", "<cmd>w<cr>", { silent = true })

-- Quit with leader key
nnoremap("<leader>q", "<cmd>q<cr>", { silent = true })

-- Save and Quit with leader key
nnoremap("<leader>wq", "<cmd>wq<cr>", { silent = true })

-- Center buffer while navigating
nnoremap("<C-u>", "<C-u>zz")
nnoremap("<C-d>", "<C-d>zz")
nnoremap("{", "{zz")
nnoremap("}", "}zz")
nnoremap("N", "Nzz")
nnoremap("n", "nzz")
nnoremap("G", "Gzz")
nnoremap("gg", "ggzz")
nnoremap("<C-i>", "<C-i>zz")
nnoremap("<C-o>", "<C-o>zz")
nnoremap("%", "%zz")
nnoremap("*", "*zz")
nnoremap("#", "#zz")

-- Press 'S' for quick find/replace for the word under the cursor
nnoremap("S", function()
    local cmd = ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>"
    local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
    vim.api.nvim_feedkeys(keys, "n", false)
end)

-- Goto next diagnostic of any severity
nnoremap("]d", function()
    vim.diagnostic.goto_next({})
    vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous diagnostic of any severity
nnoremap("[d", function()
    vim.diagnostic.goto_prev({})
    vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto next error diagnostic
nnoremap("]e", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
    vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous error diagnostic
nnoremap("[e", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
    vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Move text up/down
nnoremap("<C-j>", ":m .+1<CR>==")
nnoremap("<C-k>", ":m .-2<CR>==")
vnoremap("<C-j>", ":m '>+1<CR>gv=gv")
vnoremap("<C-k>", ":m '<-2<CR>gv=gv")

-- Clear search results
nnoremap("<leader>h", "<CMD>nohlsearch<CR>")

inoremap("jj", "<ESC>")
