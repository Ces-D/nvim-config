local plugins = {
  { "nvim-lua/plenary.nvim" },

  { "lewis6991/impatient.nvim" },

  { "wbthomason/packer.nvim" },

  { "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons",
    config = function()
      require("plugins.configs.others").devicons()
    end
  },

  { "lukas-reineke/indent-blankline.nvim",
    module = "indent_blankline",
    config = function()
      require("plugins.configs.others").indent_blankline()
    end
  },

  { "nvim-treesitter/nvim-treesitter",
    module = "nvim-treesitter",
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    config = function()
      require("plugins.configs.treesitter")
    end
  },

  ------------------- ui -------------------
  { "akinsho/bufferline.nvim",
    tag = "v2.*",
    config = function()
      require("plugins.configs.bufferline")
    end,
  },

  { 'nvim-lualine/lualine.nvim',
    config = function()
      require("lualine").setup {}
    end
  },

  { "akinsho/toggleterm.nvim",
    tag = "*",
    config = function()
      require("plugins.configs.toggleterm")
    end
  },

  { "EdenEast/nightfox.nvim",
    config = function()
      require("plugins.configs.others").theme()
      vim.cmd [[colorscheme Carbonfox]]
    end
  },

  ------------------- git stuff -------------------
  { "lewis6991/gitsigns.nvim",
    config = function()
      require("plugins.configs.gitsigns")
    end,
  },

  ------------------- lsp stuff -------------------
  { "williamboman/mason.nvim" },

  { "neovim/nvim-lspconfig",
    config = function()
      require("plugins.configs.lspconfig")
    end
  },

  { "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("plugins.configs.others").null()
    end
  },

  ------------------- load luasnips + cmp related in insert mode only -------------------
  { "L3MON4D3/LuaSnip",
    tag = "v<CurrentMajor>.*",
    config = function()
      require("plugins.configs.others").luasnip()
    end
  },

  { "rafamadriz/friendly-snippets" },

  { "hrsh7th/nvim-cmp",
    config = function()
      require("plugins.configs.cmp")
    end
  },

  { "saadparwaiz1/cmp_luasnip", after = "LuaSnip" },
  { "hrsh7th/cmp-nvim-lua", after = "cmp_luasnip" },
  { "hrsh7th/cmp-nvim-lsp", after = "cmp-nvim-lua" },
  { "hrsh7th/cmp-buffer", after = "cmp-nvim-lsp" },
  { "hrsh7th/cmp-path", after = "cmp-buffer" },

  ------------------- misc plugins -------------------
  { "windwp/nvim-autopairs",
    config = function()
      require("plugins.configs.others").autopairs()
    end
  },
  { "windwp/nvim-ts-autotag",
    config = function()
      require("plugins.configs.others").autotag()
    end
  },
  { "numToStr/Comment.nvim",
    module = "Comment",
    keys = { "gc", "gb" },
    config = function()
      require("plugins.configs.others").comment()
    end,
  },

  ------------------- file managing , picker etc -------------------
  { "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require("plugins.configs.nvimtree")
    end
  },

  { "BurntSushi/ripgrep" },

  { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },

  { "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    config = function()
      require("plugins.configs.telescope")
    end,
  }

}

-- load the plugins
local present, packer = pcall(require, "packer")

if present then
  local init_options = require("plugins.configs.others").packer_init()
  packer.init(init_options)

  for _, config in pairs(plugins) do
    packer.use(config)
  end

else
  vim.api.nvim_err_writeln("packer missing")
end
