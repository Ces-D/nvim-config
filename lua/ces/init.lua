----------------------------------------
-- Options --
----------------------------------------
local vim_opt = vim.opt
local vim_g = vim.g
vim_g.mapleader = " "
vim_g.maplocalleader = " "
vim_opt.nu = false
vim_opt.rnu = false
vim_opt.numberwidth = 1
vim_opt.tabstop = 2
vim_opt.softtabstop = 2
vim_opt.expandtab = true
vim_opt.smartindent = true
vim_opt.shiftwidth = 2
vim_opt.breakindent = true
vim_opt.incsearch = true
vim_opt.hlsearch = true
vim_opt.wrap = true
vim_opt.splitbelow = true
vim_opt.splitright = true
vim_opt.mouse = "a"
vim_opt.ignorecase = false
vim_opt.smartcase = true
vim_opt.incsearch = true
vim_opt.hlsearch = true
vim_opt.updatetime = 200
vim_opt.completeopt = { "menu", "noselect", "preview" }
vim_opt.undofile = false
vim_opt.backup = false
vim_opt.writebackup = false
vim_opt.termguicolors = true
vim_opt.signcolumn = "yes"
vim_opt.clipboard = "unnamedplus"
vim_opt.cursorline = false
vim_opt.scrolloff = 8
vim_opt.winborder = "rounded"
vim_opt.list = true
vim_opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

local plugins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "matchit",
    "tar",
    "tarPlugin",
    "rrhelper",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
    "tutor",
    "rplugin",
    "synmenu",
    "optwin",
    "compiler",
    "ftplugin",
}

for _, plugin in pairs(plugins) do
    vim_g["loaded_" .. plugin] = 1
end

----------------------------------------
-- Keymaps --
----------------------------------------
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

----------------------------------------
-- Plugins --
----------------------------------------
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim_opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    spec = { { import = "ces/plugins" } },
    install = { colorscheme = { "habamax" } },
    checker = { enabled = true },
})
