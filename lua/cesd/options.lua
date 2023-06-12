local opt = vim.opt
local g = vim.g

g.mapleader = " "

opt.laststatus = 0
opt.showmode = true

opt.title = true
opt.clipboard = "unnamedplus"
opt.fileencoding = "utf-8"
opt.spell = false

-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.autoindent = true
opt.tabstop = 2
opt.softtabstop = 2

opt.fillchars = { eob = " " }
opt.mouse = "a"

-- Text Rendering
opt.linebreak = false
opt.encoding = "utf-8"
opt.scrolloff = 1
opt.sidescrolloff = 5
opt.wrap = true

-- Search
opt.hlsearch = true
opt.incsearch = true
opt.smartcase = true

-- Numbers
opt.relativenumber = true
opt.number = true
opt.numberwidth = 3
opt.ruler = false

-- Interface
opt.wildmenu = true
opt.cursorline = true

-- disable nvim intro
opt.shortmess:append "sI"


opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.background = "light"
opt.timeoutlen = 300
opt.undofile = true
opt.writebackup = false

-- Performance
opt.lazyredraw = true

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- disable some builtin vim plugins
local disabled_plugins = {
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

for _, plugin in pairs(disabled_plugins) do
  g["loaded_" .. plugin] = 1
end
