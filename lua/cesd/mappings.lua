local M = {}

M.general = {
  ------------------------- INSERT MODE -------------------------
  i = {
    ["<C-H>"] = { "<ESC>^i", "beginning of line" },
    ["<C-L>"] = { "<End>", "end of line" },
    -- navigate within insert mode
    ["<C-h>"] = { "<Left>", "move left" },
    ["<C-l>"] = { "<Right>", "move right" },
    ["<C-j>"] = { "<Down>", "move down" },
    ["<C-k>"] = { "<Up>", "move up" },
  },
  ----------------------- NORMAL MODE -------------------------
  n = {
    -- common function

    -- switch between windows
    ["<left>"] = { "<C-w>h", "window left" },
    ["<right>"] = { "<C-w>l", "window right" },
    ["<down>"] = { "<C-w>j", "window down" },
    ["<up>"] = { "<C-w>k", "window up" },
    -- move text
    ["<C-k>"] = { ":m .-2<CR>==", "move text up" },
    ["<C-j>"] = { ":m .+1<CR>==", "move text down" },
    -- basic buffer handling
    ["<leader>w"] = { "<cmd>w<cr>", "save file" },
    ["<leader>q"] = { "<cmd>q<cr>", "quit file" },
    ["<leader>wq"] = { "<cmd>wq<cr>", "save then quit file" },
    ["<leader>bd"] = { "<cmd>bd<cr>", "delete buffer" },
    -- highlight
    ["<leader>h"] = { "<cmd>nohlsearch<cr>", "no highlight" },
  },
  ----------------------- VISUAL MODE -------------------------
  v = {
    -- common functions

    -- move text
    ["<C-j>"] = { ":m '>+1<CR>gv=gv", "move text up" },
    ["<C-k>"] = { ":m '<-2<CR>gv=gv", "move text down" },
  },
  ----------------------- TERMINAL MODE -------------------------
  t = {}
}

M.gitsigns = {
  n = {
    ["<leader>hS"] = { "<cmd>Gitsigns toggle_signs<cr>", "Toggle git signs" },
    ["<leader>hb"] = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "Toggle current git line blame" },
    ["<leader>hp"] = { "<cmd>Gitsigns preview_hunk<cr>", "Preview git Hunk" },
    ["<leader>hd"] = { "<cmd>lua require('gitsigns').diffthis('~')<cr>", "Preview Diff" },
  }
}

M.lspconfig = {
  n = {
    ["gD"] = {
      "<cmd>lua vim.lsp.buf.declaration()<cr>",
      "Go to LSP Declaration",
    },
    ["gd"] = {
      "<cmd>Telescope lsp_definitions<cr>",
      "Go to LSP Definitions",
    },
    ["gr"] = {
      "<cmd>Telescope lsp_references<cr>",
      "Go to LSP References"
    },
    ["gi"] = {
      "<cmd>Telescope lsp_implementation<cr>",
      "Go to LSP Implementations",
    },
    ["gt"] = {
      "<cmd>Telescope lsp_type_definitions<cr>",
      "LSP Type Definitions",
    },
    ["K"] = {
      "<cmd>lua vim.lsp.buf.hover()<cr>",
      "lsp hover",
    },
    ["ca"] = {
      "<cmd>lua vim.lsp.buf.code_action()<cr>",
      "lsp code_action",
    },
    ["<leader>f"] = {
      "<cmd>lua vim.diagnostic.open_float()<cr>",
      "floating diagnostic",
    },
    [",e"] = {
      "<cmd>lua vim.diagnostic.goto_prev()<cr>",
      "goto prev diagnostic",
    },
    [".e"] = {
      "<cmd>lua vim.diagnostic.goto_next()<cr>",
      "goto next diagnostic",
    },
    ["<leader>fm"] = {
      "<cmd>lua vim.lsp.buf.format()<cr>",
      "lsp formatting",
    },
  }
}

M.telescope = {
  n = {
    -- find
    ["<leader>ff"] = { "<cmd> Telescope find_files no-ignore=true hidden=true <CR>", "find files" },
    ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "find all" },
    ["<leader>fw"] = { "<cmd> Telescope live_grep <CR>", "find words" },
    ["<leader>gr"] = { "<cmd> Telescope lsp_references <cr>", "find references" },
    ["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "find buffers" },
    ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "help page" },
    ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "find oldfiles" },
    ["<leader>tk"] = { "<cmd> Telescope keymaps <CR>", "show keys" },
    -- git
    ["<leader>cm"] = { "<cmd> Telescope git_commits <CR>", "git commits" },
    ["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "git status" },
    -- pick a hidden term
    ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "pick hidden term" },
    -- color scheme
    ["<leader>cs"] = { ":lua require('cesd.colors').telescope_choose_colors()<CR>", "toggle color schemes" }
  },
}

return M
