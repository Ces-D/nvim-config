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
    config = function()
      setups.treesitter()
    end
  },

  --- Git
  {
    "lewis6991/gitsigns.nvim",
    lazy = true,
    config = function()
      setups.git()
    end
  },
  {
    "sindrets/diffview.nvim",
    lazy = true,
    config = function()
      setups.diffview()
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
    "AlexvZyl/nordic.nvim",
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
    lazy = true,
    dependencies = {
      "MunifTanjim/nui.nvim",
      config = function()
        require("chatgpt").setup()
      end
    }
  }

}
