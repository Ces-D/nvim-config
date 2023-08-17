local settings = require("cesd2.core.settings")
local keymaps = require("cesd2.plugins.utils.plugin_keymaps")

return {
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = { "BufReadPre" },
    dependencies = {
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/nvim-cmp" },
      {
        "ray-x/lsp_signature.nvim",
        config = function()
          require("lsp_signature").setup({
            zindex = 45, -- avoid overlap with nvim.cmp
            handler_opts = { border = settings["open_win_config"].border },
          })
        end
      },
    },
    config = function()
      local nvim_lsp = require("lspconfig")
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      local open_win_config = settings["open_win_config"]
      require("lspconfig.ui.windows").default_options.border = open_win_config.border

      mason.setup({ ui = { border = open_win_config.border, } })

      mason_lspconfig.setup({
        ensure_installed = require("cesd2.core.settings").mason_lsp_deps,
      })

      local opts = {
        capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
      }

      local function lsp_handlers(lsp_name)
        local servers = require("cesd2.plugins.utils.lsp_servers")
        local custom_lsp_server = servers[lsp_name]

        if type(custom_lsp_server) == "table" then
          nvim_lsp[lsp_name].setup(vim.tbl_deep_extend("force", opts, custom_lsp_server))
          return
        else
          nvim_lsp[lsp_name].setup(opts)
        end
      end

      mason_lspconfig.setup_handlers({ lsp_handlers })
    end
  },

  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter" },
    dependencies = {
      { "L3MON4D3/LuaSnip" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-buffer" },
    },
    config = function()
      require("luasnip.loaders.from_lua").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load()

      local cmp = require("cmp")
      cmp.setup({
        preselect = cmp.PreselectMode.Item,
        window = {
          completion = {
            border = settings["open_win_config"].border,
            winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,Search:PmenuSel",
            scrollbar = false,
          },
          documentation = {
            border = settings["open_win_config"].border,
            winhighlight = "Normal:CmpDoc",
          },
        },
        sorting = { priority_weight = 2 },
        mapping = cmp.mapping.preset.insert(keymaps["cmp"]()),
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        formatting = {
          fields = { "abbr", "kind", "menu" },
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
        },
      })
    end
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre" },
    config = function()
      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics
      local code_actions = null_ls.builtins.code_actions

      null_ls.setup({
        debug = false,
        sources = {
          formatting.prettierd,
          formatting.rustfmt,
          formatting.stylua,
          diagnostics.cspell.with({ filetypes = { "markdown", "html" } }),
          code_actions.cspell.with({ filetypes = { "markdown", "html" } })
        },
      })
    end,
  },



  {
    "zbirenbaum/copilot.lua",
    lazy = true,
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        keymap = keymaps["copilot"],
        filetypes = settings["copilot_filetypes"]
      })
    end,
  },

  {
    "simrat39/rust-tools.nvim",
    lazy = true,
    ft = "rust",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("rust-tools").setup({
        tools = { -- rust-tools options

          -- how to execute terminal commands
          -- options right now: termopen / quickfix
          executor = require("rust-tools.executors").termopen,

          -- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
          reload_workspace_from_cargo_toml = true,

          -- These apply to the default RustSetInlayHints command
          inlay_hints = {
            -- automatically set inlay hints (type hints)
            -- default: true
            auto = true,

            -- Only show inlay hints for the current line
            only_current_line = false,

            -- whether to show parameter hints with the inlay hints or not
            -- default: true
            show_parameter_hints = true,

            -- prefix for parameter hints
            -- default: "<-"
            parameter_hints_prefix = "<- ",

            -- prefix for all the other hints (type, chaining)
            -- default: "=>"
            other_hints_prefix = "=> ",

            -- whether to align to the length of the longest line in the file
            max_len_align = false,

            -- padding from the left if max_len_align is true
            max_len_align_padding = 1,

            -- whether to align to the extreme right or not
            right_align = false,

            -- padding from the right if right_align is true
            right_align_padding = 7,

            -- The color of the hints
            highlight = "Comment",
          },

          -- options same as lsp hover / vim.lsp.util.open_floating_preview()
          hover_actions = {

            -- the border that is used for the hover window
            -- see vim.api.nvim_open_win()
            border = settings["open_win_config"].border,

            -- whether the hover action window gets automatically focused
            -- default: false
            auto_focus = false,
          },

        }
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    event = "BufReadPost",
    dependencies = {
      { "BurntSushi/ripgrep" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim",    build = "make" },
      { "jvgrootveld/telescope-zoxide" },
      { "nvim-telescope/telescope-live-grep-args.nvim" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = settings["telescope_ignore_patterns"]
        },
        pickers = {
          buffers = {
            ignore_current_buffer = true,
            sort_lastused = true,
            sort_mru = true
          }
        },
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
          }
        }
      })
      keymaps["telescope"]()
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    event = "BufReadPost",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      { "nvim-treesitter/nvim-treesitter-context" },
    },
    config = function()
      require("nvim-treesitter.configs").setup({})
    end
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre" },
    config = function()
      require("gitsigns").setup({})
    end
  }

}
