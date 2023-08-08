local treesitter_servers = {
  "bash", "html", "javascript", "json", "lua",
  "markdown", "markdown_inline", "python", "tsx",
  "typescript", "vim", "yaml", "lua", "css",
  "html", "rust", "dockerfile"
}

local lsp_config_servers = {
  "pyright", "tsserver", "lua_ls",
  "rust_analyzer", "cssls", "cssmodules_ls",
  "html", "jsonls", "svelte", "marksman", "dockerls",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    dependencies = {
      'nvim-treesitter/nvim-treesitter-refactor'
    },
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = treesitter_servers,
      highlight = { enable = true },
      indent = { enable = true, disable = { "yaml", "python", "html" } },
      context_commentstring = {
        enable = true,
        enable_autocmd = false
      },
      incremental_selection = { enable = true },
      refactor = {
        highlight_definitions = {
          enable = true,
          -- Set to false if you have an `updatetime` of ~100.
          clear_on_cursor_move = true,
        },
        highlight_current_scope = { enable = false },
      },
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
    "neovim/nvim-lspconfig",
    lazy = false,
    branch = "master",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason.nvim",          build = ":MasonUpdate" },
      { "williamboman/mason-lspconfig.nvim" },
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
    },
    config = function()
      require("mason").setup()
      local mason_lsp = require("mason-lspconfig")


      mason_lsp.setup({ ensure_installed = lsp_config_servers })

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local handlers     = {
        function(server_name)
          require("lspconfig")[server_name].setup { capabilities = capabilities }
        end,

        ["lua_ls"] = function()
          require("lspconfig")["lua_ls"].setup {
            capabilities = capabilities,
            settings = {
              ["lua_ls"] = {
                diagnostics = { globals = { "vim" } },
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
          }
        end,

        ["rust_analyzer"] = function()
          require("lspconfig")["rust_analyzer"].setup {
            capabilities = capabilities,
            settings = {
              ["rust-analyzer"] = {
                imports = {
                  granularity = { group = "module", },
                  prefix = "self",
                },
                cargo = {
                  buildScripts = { enable = true, },
                },
                procMacro = { enable = true },
                inlayHints = true,
              },
            }
          }
        end

      }

      mason_lsp.setup_handlers(handlers)
    end
  },

  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter" },
    dependencies = {
      { "L3MON4D3/LuaSnip" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
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
            item.kind = icons[item.kind]
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
        sources = cmp.config.sources(
          {
            { name = "luasnip" },
            { name = "nvim_lsp" },
            { name = "buffer" },
            { name = "path" },
          }
        ),
        mapping = cmp.mapping.preset.insert({
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
      })
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
