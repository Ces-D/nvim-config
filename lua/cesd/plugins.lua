local plugins = {
  { "wbthomason/packer.nvim" },
  { "nvim-lua/plenary.nvim" },
  { "lewis6991/impatient.nvim" },

  --- LSP
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "folke/neodev.nvim" },
  { "jose-elias-alvarez/null-ls.nvim" },

  --- Auto Completion
  { "hrsh7th/nvim-cmp" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-path" },

  --- Highlight, Edit, Navigate
  {
    "nvim-treesitter/nvim-treesitter",
    run = function() require("nvim-treesitter.install").update({ with_sync = true }) end,
  },

  --- Git
  { "lewis6991/gitsigns.nvim" },
  { "sindrets/diffview.nvim" },

  --- UI
  { "nvim-lualine/lualine.nvim" },
  { "akinsho/toggleterm.nvim" },
  { "kyazdani42/nvim-tree.lua" },
  { "kyazdani42/nvim-web-devicons" },
  { "lukas-reineke/indent-blankline.nvim" },
  {
    "utilyre/barbecue.nvim",
    requires = { "SmiteshP/nvim-navic" }
  },
  { "loctvl842/monokai-pro.nvim" },
  { 'projekt0n/github-nvim-theme' },
  { "windwp/nvim-autopairs" },
  { "windwp/nvim-ts-autotag" },
  { "numToStr/Comment.nvim" },

  --- Fuzzy Finders
  { "BurntSushi/ripgrep" },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "make",
    cond = vim.fn.executable "make" == 1
  },
  { "nvim-telescope/telescope.nvim" },

  --- Work Flow
  { "epwalsh/obsidian.nvim" }
}

local present, packer = pcall(require, "packer")
if present then
  packer.init({
    auto_clean = true,
    compile_on_sync = true,
    git = { clone_timeout = 6000 },
    display = {
      working_sym = "ﲊ",
      error_sym = "✗ ",
      done_sym = " ",
      removed_sym = " ",
      moved_sym = "",
      open_fn = function()
        return require("packer.util").float { border = "single" }
      end,
    },
  })

  for _, plugin in pairs(plugins) do
    packer.use(plugin)
  end
else
  vim.api.nvim_err_writeln("packer missing")
end
