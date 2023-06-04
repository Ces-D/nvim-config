local M = {}

local border = {
  { "╭", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╮", "FloatBorder" },
  { "│", "FloatBorder" },
  { "╯", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╰", "FloatBorder" },
  { "│", "FloatBorder" },
}

M.theme = function()
  local theme_present, theme = pcall(require, "github-theme")
  if not theme_present then
    vim.notify("Theme not installed")
    return
  end

  theme.setup({
    styles = {
      comments = 'italic', -- Value is any valid attr-list value `:help attr-list`
      functions = 'NONE',
      keywords = 'italic',
      variables = 'NONE',
      conditionals = 'NONE',
      constants = 'NONE',
      numbers = 'NONE',
      operators = 'NONE',
      strings = 'NONE',
      types = 'italic,bold',
    },
    palettes = {
      github_light = {
        bg = "#daf1f1",
      }
    }
  })

  local hr = tonumber(os.date('%H'))
  if hr > 9 and hr < 19 then -- day between 9am and 7pm
    vim.cmd("colorscheme github_dark")
  else                       -- night
    vim.cmd("colorscheme github_dark_high_contrast")
  end
end

M.lspConfig = function()
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
    "pyright",
    "tsserver",
    "lua_ls",
    "rust_analyzer",
    "cssls",
    "cssmodules_ls",
    "html",
    "jsonls",
    "svelte",
    "marksman",
    "dockerls"
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
    ensure_installed = servers
  }

  -- adds border to all floating windows
  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or border
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end

  mason_lsp.setup_handlers {
    function(server_name)
      lsp[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }
    end,
  }
end

M.null = function()
  local null_present, null = pcall(require, "null-ls")
  if not null_present then
    vim.notify("Null LS not installed")
  end

  null.setup {

    sources = {
      null.builtins.formatting.prettierd,
      null.builtins.formatting.rustfmt,
      null.builtins.diagnostics.cspell.with({
        filetypes = { "markdown", "html" }
      }),
      null.builtins.code_actions.cspell.with({
        filetypes = { "markdown", "html" }
      })
    },
  }
end

M.cmp = function()
  local cmp_present, cmp = pcall(require, "cmp")
  local snip_present, snip = pcall(require, "luasnip")

  if not (cmp_present and snip_present) then
    vim.notify("Completions not installed")
    return
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
    formatting = {
      fields = { 'menu', 'abbr', 'kind' },
    },
    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      ["<Tab>"] = cmp.mapping(
        function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif require("luasnip").expand_or_jumpable() then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
          else
            fallback()
          end
        end
        , { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(
        function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif require("luasnip").jumpable(-1) then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
          else
            fallback()
          end
        end
        , { "i", "s", }),
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "path" },
    }),
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
      initial_mode = "insert",
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
      file_ignore_patterns = { "node_modules", ".git" },
      path_display = { "smart" },
      winblend = 0,
      border = true,
      color_devicons = true,
      -- set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
      preview = {
        treesitter = false
      },
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
  }
end

M.treesitter = function()
  local tree_present, tree = pcall(require, "nvim-treesitter.configs")

  if not tree_present then
    vim.notify("Tree sitter not installed")
    return
  end

  tree.setup {
    ensure_installed = {
      "javascript", "typescript", "lua", "css", "html", "tsx", "python", "rust", "markdown",
      "markdown_inline", "vim", "svelte", "dockerfile"
    },
    highlight = {
      enable = true,
      use_languagetree = true,
      additional_vim_regex_highlighting = { "markdown" }
    },
    matchup = {
      enable = true
    },
    indent = { enable = true },
    incremental_selection = { enable = true, },
  }
end

M.git = function()
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
      untracked = { text = '┆' },
      changedelete = { text = '~' },
    },
    numhl = false,
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
      section_separators = { left = '', right = '' },
      component_separators = { left = '', right = '' },
      icons_enabled = false,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = { "filename", "diagnostics" },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
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
      root_folder_label = false,
      highlight_git = true,
      highlight_opened_files = "icon",
      highlight_modified = "name",
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

M.toggleterm = function()
  local toggleterm_present, toggleterm = pcall(require, "toggleterm")
  if not toggleterm_present then
    vim.notify("toggleterm is not installed")
    return
  end

  toggleterm.setup {
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    close_on_exit = true,
    shell = vim.o.shell,
    direction = "vertical",
    size = function(term)
      if term.direction == "vertical" then
        return vim.o.columns * 0.5
      elseif term.direction == "horizontal" then
        return vim.o.lines * 0.3
      end
    end,
    float_opts = {
      border = "curved",
    },
  }
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

return M
