local setups = require("cesd.setups")

return {
  {
    "folke/lazy.nvim",
    version = "*",
    config = function()
      require("lazy").setup {
        defaults = { lazy = true }
      }
    end
  },
  { "nvim-lua/plenary.nvim" },

  --- LSP
  {
    "williamboman/mason.nvim",
    dependencies = {
      { "williamboman/mason-lspconfig.nvim" },
      { "neovim/nvim-lspconfig" },
      { "folke/neodev.nvim" },
      --- Auto Completion
      { "hrsh7th/nvim-cmp" },
    },
    opts         = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
        float = { border = "single" }
      },
    },
    config       = function()
      setups.lspConfig()
    end
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      setups.null()
    end
  },

  --- Auto Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "L3MON4D3/LuaSnip" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-path" },
    },
    config = function()
      setups.cmp()
    end
  },


  --- Highlight, Edit, Navigate
  {
    "nvim-treesitter/nvim-treesitter",
    build = function() require("nvim-treesitter.install").update({ with_sync = true }) end,
    dependencies = {
      "andymass/vim-matchup",
    },
    config = function()
      setups.treesitter()
    end
  },

  --- Git
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = function()
      setups.git()
    end
  },

  --- UI
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      setups.lualine()
    end
  },
  {
    "akinsho/toggleterm.nvim",
    lazy = true,
    config = function()
      setups.toggleterm()
    end
  },
  {
    "kyazdani42/nvim-tree.lua",
    config = function()
      setups.nvimtree()
    end
  },
  { "kyazdani42/nvim-web-devicons",        lazy = true },
  { "lukas-reineke/indent-blankline.nvim", lazy = true },
  {
    "utilyre/barbecue.nvim",
    dependencies = { "SmiteshP/nvim-navic" }
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    config = function()
      setups.theme()
    end
  },

  --- Fuzzy Finders
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "BurntSushi/ripgrep" },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = vim.fn.executable "make" == 1
      },
    },
    config = function()
      setups.telescope()
    end
  },

  --- Work Flow
  {
    "epwalsh/obsidian.nvim",
    lazy = true,
    config = function()
      setups.obsidion()
    end
  },
  {
    "windwp/nvim-ts-autotag",
    lazy = true,
    config = function()
      setups.ts_autotag()
    end
  },
  {
    "numToStr/Comment.nvim",
    lazy = true,
    config = function()
      setups.comment()
    end
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end
  },
  {
    "jackMort/ChatGPT.nvim",
    -- commit = '8820b99c', -- March 6th 2023, before submit issue
    lazy = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    },
    config = function()
      require("chatgpt").setup {
        -- keymap = {
        --   close = "<C-c>",
        -- submit = "<C-s>",
        --   yank_last = "<C-y>",
        --   yank_last_code = "<C-k>",
        --   scroll_up = "<C-u>",
        --   scroll_down = "<C-d>",
        --   toggle_settings = "<C-o>",
        --   new_session = "<C-n>",
        cycle_windows = "<C-cw>",
        --   -- in the Sessions pane
        --   select_session = "<Space>",
        --   rename_session = "r",
        --   delete_session = "d",
        -- }
      }
    end
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        panel = {
          enabled = false,
          auto_refresh = true
        },
        suggestion = {
          auto_trigger = true,
          keymap = { accept = "<C-J>", next = "<C-K>" }
        },
        filetypes = {
          markdown = true,
          rust = true,
          javascript = true,
          typescript = true,
          python = true,
          lua = true
        }
      }
    end
  } }
