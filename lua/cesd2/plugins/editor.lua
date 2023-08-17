local keymaps = require("cesd2.plugins.utils.plugin_keymaps")

return {
  {
    "nvim-lualine/lualine.nvim",
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          disabled_filetypes = { statusline = { "alpha" } },
          component_separators = "",
          sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff', 'filename' },
            lualine_c = { { "diagnostics", symbols = { error = " ", warn = " ", hint = " ", info = " ", } } },
            lualine_x = { 'encoding', 'fileformat', 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = { 'location' }
          },
          extensions = {
            "nvim-tree",
            "toggleterm",
            "fzf"
          },
        }
      })
    end
  },

  {
    "nvim-tree/nvim-tree.lua",
    event = "BufEnter",
    cmd = {
      "NvimTreeToggle",
      "NvimTreeOpen",
      "NvimTreeFindFile",
      "NvimTreeFindFileToggle",
      "NvimTreeRefresh",
    },
    config = function()
      keymaps.nvim_tree_keymaps()

      require("nvim-tree").setup({
        disable_netrw = true,
        hijack_cursor = true,
        update_focused_file = { enable = true, },
        diagnostics = {
          enable = false,
          show_on_dirs = true,
          show_on_open_dirs = false,
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
            enable = true
          },
        },
        actions = {
          open_file = {
            quit_on_open = true
          }
        },
      })
    end,
  },

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
      float_opts = { border = "curved", winblend = 3,
      },
    }
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

  { 'nvim-tree/nvim-web-devicons' },

  {
    "Shatur/neovim-ayu",
    lazy = false,
    config = function()
      require("ayu").setup({})
    end
  }
}
