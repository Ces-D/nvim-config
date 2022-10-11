local M = {}

M.devicons = function()
  local present, devicons = pcall(require, "nvim-web-devicons")

  if not present then
    return
  end

  devicons.setup {}
end

M.indent_blankline = function()
  local present, blankline = pcall(require, "indent_blankline")

  if not present then
    return
  end

  blankline.setup { show_end_of_line = true }
end

M.theme = function()
  local present, theme = pcall(require, "nightfox")

  if not present then
    return
  end

  theme.setup {
    options = {
      styles = {
        comments = 'italic',
        keywords = 'bold'
      }
    }
  }
end

M.luasnip = function()
  local present, luasnip = pcall(require, "luasnip")

  if not present then
    return
  end

  local options = {
    history = true,
  }

  luasnip.config.set_config(options)
  require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.luasnippets_path or "" }
  require("luasnip.loaders.from_vscode").lazy_load()
end

M.null = function()
  local present, null = pcall(require, "null-ls")

  if not present then
    return
  end

  null.setup {
    sources = {
      null.builtins.diagnostics.tsc,
      null.builtins.formatting.black,
      null.builtins.completion.spell,
    }
  }
end

M.autopairs = function()
  local present1, autopairs = pcall(require, "nvim-autopairs")
  local present2, cmp = pcall(require, "cmp")

  if not (present1 and present2) then
    return
  end

  local options = {
    fast_wrap = {},
    disable_filetype = { "TelescopePrompt", "vim" },
  }

  autopairs.setup(options)

  local cmp_autopairs = require "nvim-autopairs.completion.cmp"
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

M.autotag = function()
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

  local options = {}
  nvim_comment.setup(options)
end

M.packer_init = function()
  return {
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
  }
end

return M
