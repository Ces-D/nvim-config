local opt = vim.opt
local g = vim.g

-- line numbers
opt.relativenumber = true
opt.number = true
opt.numberwidth = 3

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- line wrapping
opt.wrap = true
opt.wrapmargin = 120

-- search settings
opt.hlsearch = true
opt.smartcase = true
opt.incsearch = true

-- cursor line
opt.cursorline = true

-- status line
opt.laststatus = 3
opt.showmode = false

-- appearance
opt.signcolumn = "yes"
opt.background = "dark"
opt.termguicolors = true
g.base15_colorspace = 256

-- split
opt.splitright = true
opt.splitbelow = true

-- clipboard
opt.clipboard = "unnamedplus"

-- misc
opt.undofile = true
opt.backup = false
opt.writebackup = false

opt.iskeyword:append("-")
