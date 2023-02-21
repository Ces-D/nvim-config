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
    ["<leader>gS"] = { "<cmd>Gitsigns toggle_signs<cr>", "Toggle git signs" },
    ["<leader>gb"] = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "Toggle current line blame" }
  }
}

M.comment = {
  n = {
    ["<leader>/"] = {
      "<cmd>lua require('Comment.api').toggle.linewise.current()<cr>",
      "toggle comment",
    },
  },
  v = {
    ["<leader>/"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "toggle comment",
    },
  },
}

M.nvimTree = {
  n = {
    ["<leader>e"] = { "<cmd>NvimTreeToggle<cr>", "Toggle Nvim tree" },
    ["<leader>o"] = { "<cmd>NvimTreeFocus<cr>", "Focus Nvim tree" }
  }
}

M.lspconfig = {
  -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions

  n = {
    ["gD"] = {
      "<cmd>lua vim.lsp.buf.declaration()<cr>",
      "lsp declaration",
    },

    ["gd"] = {
      "<cmd>lua vim.lsp.buf.definition()<cr>",
      "lsp definition",
    },

    ["K"] = {
      "<cmd>lua vim.lsp.buf.hover()<cr>",
      "lsp hover",
    },

    ["gi"] = {
      "<cmd>lua vim.lsp.buf.implementation()<cr>",
      "lsp implementation",
    },

    ["<leader>ls"] = {
      "<cmd>lua vim.lsp.buf.signature_help()<cr>",
      "lsp signature_help",
    },

    ["<leader>D"] = {
      "<cmd>lua vim.lsp.buf.type_definition()<cr>",
      "lsp definition type",
    },

    ["<leader>ca"] = {
      "<cmd>lua vim.lsp.buf.code_action()<cr>",
      "lsp code_action",
    },

    ["<leader>f"] = {
      "<cmd>lua vim.diagnostic.open_float()<cr>",
      "floating diagnostic",
    },

    ["[d"] = {
      "<cmd>lua vim.diagnostic.goto_prev()<cr>",
      "goto prev",
    },

    ["d]"] = {
      "<cmd>lua vim.diagnostic.goto_next()<cr>",
      "goto_next",
    },

    ["<leader>q"] = {
      "<cmd>lua vim.diagnostic.setloclist()<cr>",
      "diagnostic setloclist",
    },

    ["<leader>fm"] = {
      "<cmd>lua vim.lsp.buf.format()<cr>",
      "lsp formatting",
    },

    ["<leader>wa"] = {
      "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>",
      "add workspace folder",
    },

    ["<leader>wr"] = {
      "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>",
      "remove workspace folder",
    },

    ["<leader>wl"] = {
      "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>",
      "list workspace folders",
    },
  },
}

M.telescope = {
  n = {
    -- find
    ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "find files" },
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
  },
}

return M
