local packer  = require'packer'

packer.startup(function(use)
	use 'wbthomason/packer.nvim'
	use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
	use 'nvim-lua/plenary.nvim'
	use 'nvim-lua/telescope.nvim'
	-- use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
	use 'nvim-telescope/telescope-file-browser.nvim'

	-- LSP
	use 'neovim/nvim-lspconfig'
	use 'williamboman/nvim-lsp-installer'

	-- FORMATTING AND LINTING
	use 'jose-elias-alvarez/null-ls.nvim'

	-- AUTOCOMPLETE
	use { 'hrsh7th/nvim-cmp',
		requires = {
			'hrsh7th/cmp-buffer', -- buffer completion
			'hrsh7th/cmp-nvim-lsp', -- completion source
			'hrsh7th/cmp-nvim-lua',
			'hrsh7th/cmp-path' -- path completion
		}
	}

	-- SNIPPET ENGINE
	use { "L3MON4D3/LuaSnip" }
	use { 'saadparwaiz1/cmp_luasnip' }

	-- GIT
	use 'TimUntersberger/neogit'

	-- EDITING
	use 'windwp/nvim-autopairs'
	use { 'prettier/vim-prettier', run='yarn install' }
	use { 'phaazon/hop.nvim', branch='v1' }
	use { 'nvim-lualine/lualine.nvim',
	  requires = {
	    'kyazdani42/nvim-web-devicons',opt=true
	  }
	}
	use { 'kyazdani42/nvim-tree.lua', tag='nightly' }

	-- THEME
	use ({ 'catppuccin/nvim', as='catppuccin' })

	end
	)

-- require plugin setups
require'plugins.autopairs'
require'plugins.lualine'
require'plugins.treesitter'
require'plugins.telescope'
require'plugins.null-ls'
require'plugins.neogit'
require'plugins.n-tree'
require'plugins.cmp'
