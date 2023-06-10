return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "lua",
        "css",
        "html",
        "rust",
        "dockerfile"
      },
      highlight = { enable = true },
      indent = { enable = true, disable = { "yaml", "python", "html" } },
      context_commentstring = { enable = true },
      incremental_selection = { enable = true }
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    tag = "0.1.1",
    dependencies = {
      { "BurntSushi/ripgrep" },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = vim.fn.executable "make" == 1
      },
      { "nvim-lua/plenary.nvim" },
      { "BurntSushi/ripgrep" },
      { "nvim-treesitter/nvim-treesitter" }
    },
    config = function()
      require("telescope").setup({
        defaults = {
          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "   ",
          border = true,
          dynamic_preview_title = true,
          hl_result_eol = true,
          sorting_strategy = "ascending",
          file_ignore_patterns = {
            ".git/", "target/", "docs/", "vendor/*", "%.lock", "__pycache__/*", "%.sqlite3", "%.ipynb", "node_modules/*",
            -- "%.jpg", "%.jpeg", "%.png", "%.svg", "%.otf", "%.ttf",
            "%.webp", ".dart_tool/", ".github/", ".gradle/", ".idea/", ".settings/", ".vscode/", "__pycache__/",
            "build/", "gradle/", "node_modules/", "%.pdb", "%.dll", "%.class", "%.exe", "%.cache", "%.ico", "%.pdf",
            "%.dylib", "%.jar", "%.docx", "%.met", "smalljre_*/*", ".vale/", "%.burp", "%.mp4", "%.mkv", "%.rar",
            "%.zip", "%.7z", "%.tar", "%.bz2", "%.epub", "%.flac", "%.tar.gz",
          },
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          path_display = { "smart" },
          mappings = {
            n = {
              ["q"] = require("telescope.actions").close,
              ["<esc>"] = require("telescope.actions").close,
            },
          },
        },
        pickers = {
          buffers = {
            ignore_current_buffer = true,
            sort_lastused = true,
            sort_mru = true,
          },
          colorscheme = {
            enable_preview = true
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
    end,
  },

  {
    "neovim/nvim-lspconfig",
    lazy = false,
    branch = "master",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "williamboman/mason.nvim",
        config = function()
          require("mason").setup {
            defaults = { lazy = true }
          }
        end
      },
      { "williamboman/mason-lspconfig.nvim" },
      -- { "L3MON4D3/LuaSnip" },
      -- { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      -- { "hrsh7th/cmp-path" },
      -- { "hrsh7th/cmp-buffer" },
    },
    config = function()
      local servers = {
        pyright = {},
        tsserver = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                checkThirdParty = false,
              },
              format = {
                enable = true,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  continuation_indent_size = "2",
                },
              },
            }
          }
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              inlayHints = true,
            },
          },
        },
        cssls = {},
        cssmodules_ls = {},
        html = {},
        jsonls = {},
        svelte = {},
        marksman = {},
        dockerls = {}

      }

      local ext_capabilities = vim.lsp.protocol.make_client_capabilities()
      -- extends capabilities using the cmp_nvim_lsp capabilities
      local capabilities = vim.tbl_deep_extend("force", {}, ext_capabilities,
        require("cmp_nvim_lsp").default_capabilities(),
        { textDocument = { foldingRange = { dynamicRegistration = false, lineFoldingOnly = true } } }
      )

      -- Setup lsp servers
      local function server_setup(server)
        if servers[server] and servers[server].disabled then
          return
        end

        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        require("lspconfig")[server].setup(server_opts)
      end


      local available = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      local ensure_installed = {}

      -- Call the server setup or add to ensure_installed
      for server, server_opts in pairs(servers) do
        if server_opts then
          if not vim.tbl_contains(available, server) then
            server_setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      require("mason-lspconfig").setup({ ensure_installed = ensure_installed })
      require("mason-lspconfig").setup_handlers({ server_setup })
    end
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = require("cesd.icons").gitsigns.add },
        delete = { text = require("cesd.icons").gitsigns.delete },
        change = { text = require("cesd.icons").gitsigns.change },
        topdelhfe = { text = require("cesd.icons").gitsigns.topdelhfe },
        changedelete = { text = require("cesd.icons").gitsigns.changedelete },
        untracked = { text = require("cesd.icons").gitsigns.untracked },
      },
      preview_config = { border = "rounded" },
    }
  },

  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter" },
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        dependencies = {
          "rafamadriz/friendly-snippets",
          config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_snipmate").lazy_load()
          end,
        },
        opts = {
          history = true,
          delete_check_events = "TextChanged",
        },
        keys = {
          {
            "<tab>",
            function()
              return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
            end,
            expr = true,
            silent = true,
            mode = "i",
          },
          {
            "<tab>",
            function()
              require("luasnip").jump(1)
            end,
            mode = "s",
          },
          {
            "<s-tab>",
            function()
              require("luasnip").jump(-1)
            end,
            mode = { "i", "s" },
          },
        },
      },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
    },
    config = function()
      local cmp = require("cmp")

      return {
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end
        },
        window = {
          completion = { border = "rounded" },
          documentation = { border = "rounded" },
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            local icons = require("cesd.icons").kinds
            item.kindd = icons[item.kind]
            item.menu = ({
              nvim_lsp = "Lsp",
              nvim_lua = "Lua",
              luasnip = "Snippet",
              buffer = "Buffer",
              path = "Path",
            })[entry.source.name]
            return item
          end
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        mapping = cmp.mapping.preset.insert({
          ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }), { "i", "c" }),
          ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }), { "i", "c" }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<Esc>"] = cmp.mapping(function(fallback)
            require("luasnip").unlink_current()
            fallback()
          end),
        }),
      }
    end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    lazy = false,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "hrsh7th/nvim-cmp", "nvim-lua/plenary.nvim" },
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
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<C-J>",
          }
        },
        filetypes = {
          markdown = true,
          lua = true,
          typescript = true
        }
      })
    end,
  }
}
