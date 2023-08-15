local keymaps = require("cesd2.plugins.utils.plugin_keymaps")
local core_icons = require("cesd2.core.icons")

return {
  {
    "nvim-lualine/lualine.nvim",
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    config = function()
      local icons = {
        diagnostics = core_icons.get("diagnostics", true),
        git = core_icons.get("git", true),
        git_nosep = core_icons.get("git"),
        misc = core_icons.get("misc", true),
        ui = core_icons.get("ui", true),
      }

      require("lualine").setup({
        options = {
          icons_enabled = true,
          disabled_filetypes = { statusline = { "alpha" } },
          component_separators = "",
          section_separators = { left = "", right = "" }
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
            icon = icons.git_nosep.Branch,
          },
          lualine_c = {
            {
              "branch",
              icon = icons.git_nosep.Branch,
            },
            {
              "diff",
              symbols = {
                added = icons.git.Add,
                modified = icons.git.Mod_alt,
                removed = icons.git.Remove,
              },
              padding = { right = 1 },
            },
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              sections = { "error", "warn", "info", "hint" },
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warning,
                info = icons.diagnostics.Information,
                hint = icons.diagnostics.Hint_alt,
              },
            },
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        extensions = {
          "nvim-tree",
          "toggleterm",
        },
      })
    end
  },

  {
    "nvim-tree/nvim-tree.lua",
    lazy = true,
    cmd = {
      "NvimTreeToggle",
      "NvimTreeOpen",
      "NvimTreeFindFile",
      "NvimTreeFindFileToggle",
      "NvimTreeRefresh",
    },
    keys = keymaps["nvim-tree"],
    config = function()
      local icons = {
        diagnostics = core_icons.get("diagnostics"),
        documents = core_icons.get("documents"),
        git = core_icons.get("git"),
        ui = core_icons.get("ui"),
      }

      require("nvim-tree").setup({
        disable_netrw = true,
        hijack_cursor = true,
        update_focused_file = { enable = true, },
        diagnostics = {
          enable = false,
          show_on_dirs = true,
          show_on_open_dirs = false,
          icons = {
            hint = icons.diagnostics.Hint_alt,
            info = icons.diagnostics.Information_alt,
            warning = icons.diagnostics.Warning_alt,
            error = icons.diagnostics.Error_alt,
          },
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
        indent_markers = { enable = true, },
        renderer = {
          highlight_modified = "icon",
          indent_markers = {
            enable = false
          },
          icons = {
            webdev_colors = true,
            glyphs = {
              default = icons.documents.Default, --
              symlink = icons.documents.Symlink, --
              bookmark = icons.ui.Bookmark,
              git = {
                unstaged = icons.git.Mod_alt,
                staged = icons.git.Add,          --󰄬
                unmerged = icons.git.Unmerged,
                renamed = icons.git.Rename,      --󰁔
                untracked = icons.git.Untracked, -- "󰞋"
                deleted = icons.git.Remove,      --
                ignored = icons.git.Ignore,      --◌
              },
              folder = {
                arrow_open = icons.ui.ArrowOpen,
                arrow_closed = icons.ui.ArrowClosed,
                default = icons.ui.Folder,
                open = icons.ui.FolderOpen,
                empty = icons.ui.EmptyFolder,
                empty_open = icons.ui.EmptyFolderOpen,
                symlink = icons.ui.SymlinkFolder,
                symlink_open = icons.ui.FolderOpen,
              },
            },
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
}
