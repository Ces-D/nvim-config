local servers = {}

servers["rust_analyzer"] = {
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

servers["tsserver"] = {}

servers["lua_ls"] = {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
        disable = { "different-requires" },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
      format = { enable = true },
      telemetry = { enable = false },
      -- Do not override treesitter lua highlighting with lua_ls's highlighting
      semantic = { enable = false },
    },
  },
}

servers["html"] = {
  cmd = { "html-languageserver", "--stdio" },
  filetypes = { "html" },
  init_options = {
    configurationSection = { "html", "css", "javascript" },
    embeddedLanguages = { css = true, javascript = true },
  },
  settings = {},
  single_file_support = true,
  flags = { debounce_text_changes = 500 },
}

servers["jsonls"] = {
  flags = { debounce_text_changes = 500 },
  settings = {
    json = {
      -- Schemas https://www.schemastore.org
      schemas = {
        {
          fileMatch = { "package.json" },
          url = "https://json.schemastore.org/package.json",
        },
        {
          fileMatch = { "tsconfig*.json" },
          url = "https://json.schemastore.org/tsconfig.json",
        },
        {
          fileMatch = {
            ".prettierrc",
            ".prettierrc.json",
            "prettier.config.json",
          },
          url = "https://json.schemastore.org/prettierrc.json",
        },
        {
          fileMatch = { ".eslintrc", ".eslintrc.json" },
          url = "https://json.schemastore.org/eslintrc.json",
        },
        {
          fileMatch = {
            ".babelrc",
            ".babelrc.json",
            "babel.config.json",
          },
          url = "https://json.schemastore.org/babelrc.json",
        },
        {
          fileMatch = { "/.github/workflows/*" },
          url = "https://json.schemastore.org/github-workflow.json",
        },
      },
    }
  },
}

return servers
