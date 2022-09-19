local mappings = require("cesd.core.mappings")

local plugins = {
  {"nvim-lua/plenary.nvim", module = "plenary" },

  {"lewis6991/impatient.nvim"},

  {"wbthomason/packer.nvim"},

  {"kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons",
    config = function()
      require("cesd.plugins.configs.others").devicons()
    end
  },

  {"lukas-reineke/indent-blankline.nvim",
    module = "indent_blankline",
    config = function()
      require("cesd.plugins.configs.others").indent_blankline()
    end
  },

  {"nvim-treesitter/nvim-treesitter",
    module = "nvim-treesitter",
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    config = function()
      require("cesd.plugins.configs.treesitter")
    end
  },

  ------------------- ui -------------------
  {"akinsho/bufferline.nvim",
    module = "bufferline",
    tag = "v2.*",
    config = function()
      require("cesd.plugins.configs.bufferline")
      require("cesd.core.utils").load_mappings(mappings.bufferline)
    end
  },

  {"akinsho/toggleterm.nvim",
    module = "toggleterm",
    tag = "*",
    config = function()
      require("cesd.plugins.configs.toggleterm")
    end
  },

  {"folke/tokyonight.nvim",
    config = function()
      require("cesd.plugins.configs.others").theme()
      vim.cmd[[colorscheme tokyonight]]
    end
  },

  ------------------- git stuff -------------------
  {"lewis6991/gitsigns.nvim",
    config = function()
      require("cesd.plugins.configs.gitsigns")
      require("cesd.core.utils").load_mappings(mappings.gitsigns)
    end
  },

  ------------------- lsp stuff -------------------
  {"neovim/nvim-lspconfig"},

  {"williamboman/nvim-lsp-installer"},

  ------------------- load luasnips + cmp related in insert mode only -------------------
  {"hrsh7th/nvim-cmp",
    config = function()
      require("cesd.plugins.configs.cmp")
    end
  },

  {"L3MON4D3/LuaSnip",
    after = "nvim-cmp",
    config = function()
      require("cesd.plugins.configs.others").luasnip()
    end
  },

  {"saadparwaiz1/cmp_luasnip", after = "LuaSnip" },
  {"hrsh7th/cmp-nvim-lua", after = "cmp_luasnip" },
  {"hrsh7th/cmp-nvim-lsp", after = "cmp-nvim-lua" },
  {"hrsh7th/cmp-buffer", after = "cmp-nvim-lsp" },
  {"hrsh7th/cmp-path", after = "cmp-buffer" },

  ------------------- misc plugins -------------------
  {"windwp/nvim-autopairs",
    after = "nvim-cmp",
    config = function()
      require("cesd.plugins.configs.others").autopairs()
    end
  },

  {"numToStr/Comment.nvim",
    module = "Comment",
    keys = { "gc", "gb" },
    config = function()
      require("cesd.plugins.configs.others").comment()
      require("cesd.core.utils").load_mappings(mappings.comment)
    end,
  },

  ------------------- file managing , picker etc -------------------
  {"kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require("cesd.plugins.configs.nvimtree")
      require("cesd.core.utils").load_mappings(mappings.nvimtree)
    end,
  },

  {"nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    config = function()
      require("cesd.plugins.configs.telescope")
      require("cesd.core.utils").load_mappings(mappings.telescope)
    end,
  },

  {"BurntSushi/ripgrep"},

  {"nvim-telescope/telescope-fzf-native.nvim"}
}

require("cesd.plugins.configs.lspconfig")
require("cesd.core.utils").load_mappings(mappings.lspconfig)

-- load the plugins
local present, packer = pcall(require, "packer")

if present then
  local init_options = require("cesd.plugins.configs.others").packer_init()
  packer.init(init_options)

  for _,config in ipairs(plugins) do
    packer.use(config)
  end

 else 
  vim.api.nvim_err_writeln("packer missing")
end
