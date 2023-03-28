local setups = require("cesd.setups")

return {
  { "folke/lazy.nvim",      version = "*" },
  { "nvim-lua/plenary.nvim" },

  --- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
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
    config       = setups.lspConfig
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim" },
    config = setups.null
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
    config = setups.cmp
  },


  --- Highlight, Edit, Navigate
  {
    "nvim-treesitter/nvim-treesitter",
    build = function() require("nvim-treesitter.install").update({ with_sync = true }) end,
    config = setups.treesitter
  },

  --- Git
  { "lewis6991/gitsigns.nvim",            lazy = true,             config = setups.git },
  { "sindrets/diffview.nvim",             lazy = true,             config = setups.diffview },

  --- UI
  { "nvim-lualine/lualine.nvim",          config = setups.lualine },
  { "akinsho/toggleterm.nvim",            lazy = true,             config = setups.toggleterm },
  { "kyazdani42/nvim-tree.lua",           config = setups.nvimtree },
  { "kyazdani42/nvim-web-devicons",       lazy = true },
  { "lukas-reineke/indent-blankline.nvim" },
  {
    "utilyre/barbecue.nvim",
    dependencies = { "SmiteshP/nvim-navic" }
  },
  { "loctvl842/monokai-pro.nvim", lazy = false, config = setups.theme },
  { "windwp/nvim-autopairs" },

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
    config = setups.telescope
  },

  --- Work Flow
  { "epwalsh/obsidian.nvim",  lazy = true, config = setups.obsidion },
  { "windwp/nvim-ts-autotag", lazy = true, config = setups.ts_autotag },
  { "numToStr/Comment.nvim",  lazy = true, config = setups.comment },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  }

}
