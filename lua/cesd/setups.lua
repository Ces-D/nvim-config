local M = {}

local function border(hl_name)
  return {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
end

M.lspconfig = function()
  local lsp_present, lsp = pcall(require, "lspconfig")
  local mason_present, mason = pcall(require, "mason")
  local mason_lsp_present, mason_lsp = pcall(require, "mason-lspconfig")

  if not (lsp_present and mason_present and mason_lsp_present) then
    vim.notify("Lsp servers not installed")
    return
  end

  local function on_attach(client)
    vim.notify('Attaching to ' .. client.name)
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  local servers = {
    pyright = {},
    tsserver = {},
    lua_ls = {},
    rust_analyzer = {},
    cssls = {},
    cssmodules_ls = {},
    html = {}
  }

  mason.setup {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      }
    }
  }

  mason_lsp.setup {
    ensure_installed = vim.tbl_keys(servers)
  }

  mason_lsp.setup_handlers {
    function(server_name)
      lsp[server_name].setup {
        handlers = {
          ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border("FloatBorder") }),
          ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help,
            {
              border = "single"
            })
        },
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
      }
    end,
  }

  vim.diagnostic.config {
    float = { border = "single" }
  }
end

M.cmp = function()
  local cmp_present, cmp = pcall(require, "cmp")
  local snip_present, snip = pcall(require, "luasnip")

  if not (cmp_present and snip_present) then
    vim.notify("Completions not installed")
    return
  end


  local cmp_window = require "cmp.utils.window"

  cmp_window.info_ = cmp_window.info
  cmp_window.info = function(self)
    local info = self:info_()
    info.scrollable = false
    return info
  end

  cmp.setup {
    window = {
      border = "rounded",
      documentation = {
        border = "rounded"
      },
      completion = {
        border = "rounded",
      },
    },
    snippet = {
      expand = function(args)
        snip.lsp_expand(args.body)
      end,
    },
    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs( -4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif require("luasnip").expand_or_jumpable() then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif require("luasnip").jumpable( -1) then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "path" },
    }),
  }
end

M.null_ls = function()
  local null_present, null = pcall(require, "null-ls")
  if not null_present then
    vim.notify("Null LS not installed")
  end

  null.setup({
    sources = {
      null.builtins.formatting.prettierd,
      null.builtins.formatting.rustfmt,
      null.builtins.completion.spell,
    },
  })
end

M.treesitter = function()
  local tree_present, tree = pcall(require, "nvim-treesitter.configs")

  if not tree_present then
    vim.notify("Tree sitter not installed")
    return
  end

  tree.setup {
    ensure_installed = { "javascript", "typescript", "lua", "css", "html", "tsx", "python", "rust", "markdown", "markdown_inline" },
    highlight = {
      enable = true,
      use_languagetree = true,
      additional_vim_regex_highlighting = { "markdown" }
    },
    indent = {
      enable = true
    }, incremental_selection = {
    enable = true,
    -- keymaps = {
    --   init_selection = '<c-space>',
    --   node_incremental = '<c-space>',
    --   scope_incremental = '<c-s>',
    --   node_decremental = '<c-backspace>',
    -- },
  },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end

M.telescope = function()
  local telescope_present, telescope = pcall(require, "telescope")

  if not telescope_present then
    vim.notify("Telescope not installed")
    return
  end

  telescope.setup {
    defaults = {
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      },
      prompt_prefix = "   ",
      selection_caret = "  ",
      entry_prefix = "  ",
      initial_mode = "insert",
      selection_strategy = "reset",
      sorting_strategy = "ascending",
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
      file_sorter = require("telescope.sorters").get_fuzzy_file,
      file_ignore_patterns = { "node_modules" },
      generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
      path_display = { "truncate" },
      winblend = 0,
      border = {},
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      color_devicons = true,
      -- set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
      mappings = {
        n = { ["q"] = require("telescope.actions").close },
      },
    },
    pickers = {
      buffers = {
        ignore_current_buffer = true,
        sort_lastused = true
      }
    },
    extensions = {
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      }
    }
  }
end

M.gitsigns = function()
  local gitsigns_present, gitsigns = pcall(require, "gitsigns")
  if not gitsigns_present then
    vim.notify("Git signs not installed")
    return
  end

  gitsigns.setup {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  }
end

M.barbecue = function()
  local barbecue_present, barbecue = pcall(require, "barbecue")
  if not barbecue_present then
    vim.notify("Barbecue not installed")
    return
  end

  barbecue.setup {
    create_autocmd = true
  }
end

M.lualine = function()
  local lualine_present, lualine = pcall(require, "lualine")
  if not lualine_present then
    vim.notify("lualine is not installed")
    return
  end

  lualine.setup {
    options = {
      component_separators = '|',
      section_separators = '',
    },
  }
end

M.toggleterm = function()
  local toggleterm_present, toggleterm = pcall(require, "toggleterm")
  if not toggleterm_present then
    vim.notify("toggleterm is not installed")
    return
  end

  toggleterm.setup {
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = "curved",
    },
  }
end

M.nvimtree = function()
  local nvimtree_present, nvimtree = pcall(require, "nvim-tree")
  if not nvimtree_present then
    vim.notify("nvimtree is not installed")
    return
  end

  nvimtree.setup {
    filters = {
      dotfiles = false,
    },
    disable_netrw = true,
    hijack_netrw = true,
    ignore_ft_on_setup = { "alpha" },
    hijack_cursor = true,
    update_cwd = true,
    update_focused_file = {
      enable = true,
      update_cwd = false,
    },
    view = {
      adaptive_size = true,
      side = "left",
      width = 40,
      hide_root_folder = true,
    },
    git = {
      enable = true,
      ignore = true
    },
    filesystem_watchers = {
      enable = true,
    },
    actions = {
      open_file = {
        resize_window = true,
      },
    },
    renderer = {
      highlight_git = true,
      highlight_opened_files = "none",

      indent_markers = {
        enable = true,
      },

      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },

        glyphs = {
          default = "",
          symlink = "",
          folder = {
            default = "",
            empty = "",
            empty_open = "",
            open = "",
            symlink = "",
            symlink_open = "",
            arrow_open = "",
            arrow_closed = "",
          },
          git = {
            unstaged = "✗",
            staged = "✓",
            unmerged = "",
            renamed = "➜",
            untracked = "★",
            deleted = "",
            ignored = "◌",
          }
        },
      },
    },
  }
end

M.indentblankline = function()
  local indent_present, indent = pcall(require, "indent-blankline")
  if not indent_present then
    vim.notify("indent-blankline is not installed")
    return
  end

  indent.setup {
    char = '┊',
    show_trailing_blankline_indent = false,
  }
end

M.theme = function()
  local theme_present, theme = pcall(require, "monokai-pro")
  if not theme_present then
    vim.notify("theme not present")
    return
  end

  theme.setup {
    transparent_background = false,
    terminal_colors = true,
    devicons = true, -- highlight the icons of `nvim-web-devicons`
    italic_comments = true,
    filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
    -- Enable this will disable filter option
    day_night = {
      enable = false, -- turn off by default
      day_filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
      night_filter = "spectrum", -- classic | octagon | pro | machine | ristretto | spectrum
    },
    inc_search = "background", -- underline | background
    background_clear = {
      "float_win",
      "toggleterm",
      "telescope",
    }, -- "float_win", "toggleterm", "telescope", "which-key", "renamer", "neo-tree"
    plugins = {
      bufferline = {
        underline_selected = false,
        underline_visible = false,
      },
      indent_blankline = {
        context_highlight = "default", -- default | pro
        context_start_underline = false,
      },
    },
  }
  vim.cmd([[colorscheme monokai-pro]])
end

M.autopairs = function()
  local present1, autopairs = pcall(require, "nvim-autopairs")
  local present2, cmp = pcall(require, "cmp")
  if not (present1 and present2) then
    return
  end

  autopairs.setup({
    fast_wrap = {},
    disable_filetype = { "TelescopePrompt", "vim" },
  })

  local cmp_autopairs = require "nvim-autopairs.completion.cmp"
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

M.ts_autotag = function()
  local present, autotag = pcall(require, 'nvim-ts-autotag')
  if not present then
    return
  end

  autotag.setup()
end

M.comment = function()
  local present, nvim_comment = pcall(require, "Comment")
  if not present then
    return
  end

  nvim_comment.setup()
end

M.obsidion = function()
  local present, obsidion = pcall(require, "obsidian")
  if not present then
    return
  end

  obsidion.setup {
    dir = "~/Documents/notes/notes",
    completion = {
      nvim_cmp = true
    }
  }
end

return M
