return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
    event = "VeryLazy",
    opts = {
      icons_enabled = true,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { "filename",
          {
            "diagnostics",
            symbols = {
              error = require("cesd.icons").diagnostics.error,
              warn = require("cesd.icons").diagnostics.warn,
              info = require("cesd.icons").diagnostics.info,
              hint = require("cesd.icons").diagnostics.hint,
            },
          }
        },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    }
  },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" }
    },
    event = "BufEnter",
    keys = {
      { "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Toggle Nvim Tree" },
      { "<leader>o", "<cmd>NvimTreeFocus<cr>",          desc = "Focus Nvim Tree" }
    },
    config = function()
      require("nvim-tree").setup({
        disable_netrw = true,
        hijack_cursor = true,
        update_focused_file = {
          enable = true,
        },
        diagnostics = {
          enable = false,
          show_on_dirs = true,
          show_on_open_dirs = false
        },
        modified = {
          enable = true,
          show_on_dirs = true,
          show_on_open_dirs = false
        },
        git = {
          show_on_dirs = true,
          show_on_open_dirs = false
        },
        view = {
          width = {
            min = 30,
            max = 90
          },
        },
        renderer = {
          highlight_modified = "icon",
          indent_markers = {
            enable = false
          },
          icons = {
            webdev_colors = true,
            glyphs = {
              git = {
                unstaged = require("cesd.icons").git.unstaged,
                staged = require("cesd.icons").git.staged,
                unmerged = require("cesd.icons").git.untracked,
                renamed = require("cesd.icons").git.renamed,
                untracked = require("cesd.icons").git.untracked,
                deleted = require("cesd.icons").git.deleted,
                ignored = require("cesd.icons").git.ignored,
              }
            }
          }
        },
        actions = {
          open_file = {
            quit_on_open = true
          }
        }
      })
    end,
  },

  -- {
  --   "olivercederborg/poimandres.nvim",
  --   name = "poimandres",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     local theme = require("poimandres")
  --     vim.o.background = "dark"

  --     theme.setup({
  --     })

  --     -- local hr = tonumber(os.date('%H'))

  --     -- if hr > 7 and hr < 12 then -- day between 7am and 12pm
  --     -- else -- night


  --     -- end

  --     vim.cmd.colorscheme "poimandres"
  --   end
  -- },

  {
    "akinsho/toggleterm.nvim",
    event = { "BufReadPost", "BufNewFile" },
    version = "*",
    opts = {
      open_mapping = [[<C-\>]],
      start_in_insert = true,
      direction = "vertical",
      autochdir = false,
      size = function(term)
        if term.direction == "vertical" then
          return vim.o.columns * 0.5
        elseif term.direction == "horizontal" then
          return vim.o.lines * 0.3
        end
      end,
      float_opts = {
        border = "curved",
        winblend = 3,
      },
    },
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = { "*", "!lazy", "!neo-tree" },
      buftype = { "*", "!prompt", "!nofile" },
      user_default_options = {
        RGB = true,       -- #RGB hex codes
        RRGGBB = true,    -- #RRGGBB hex codes
        names = false,    -- "Name" codes like Blue
        RRGGBBAA = true,  -- #RRGGBBAA hex codes
        AARRGGBB = false, -- 0xAARRGGBB hex codes
        rgb_fn = true,    -- CSS rgb() and rgba() functions
        hsl_fn = true,    -- CSS hsl() and hsla() functions
        css = false,      -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true,    -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes: foreground, background
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = "background", -- Set the display mode.
        virtualtext = "■",
      },
    },
  },

  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    config = function()
      require("mini.comment").setup(
        {
          options = {
            ignore_blank_line = true,
            custom_commentstring = function()
              return require('ts_context_commentstring.internal').calculate_commentstring() or vim.bo.commentstring
            end,
          },
          mappings = {
            comment = "<leader>/",
          },
        }
      )
    end,
  },

  {
    'echasnovski/mini.surround',
    event = "VeryLazy",
    version = false,
    config = function()
      require("mini.surround").setup()
    end
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
      })
    end
  },

  {
    "windwp/nvim-ts-autotag",
    ft = {
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "tsx",
      "jsx",
      "xml",
      "markdown",
    },
    opts = {
      enable = true,
      filetypes = {
        "html",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "svelte",
        "vue",
        "tsx",
        "jsx",
        "xml",
        "markdown",
      },
    },
  },

  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  {
    'ibhagwan/smartyank.nvim',

    config = function()
      require("smartyank").setup()
    end
  }
}
