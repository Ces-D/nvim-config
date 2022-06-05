local lspconfig = require'lspconfig'
local lspinstaller = require'nvim-lsp-installer'

local function custom_on_attach(client)
	vim.notify('Attaching to '.. client.name)
end

local default_config = { on_attach = custom_on_attach }

lspinstaller.setup{}
lspconfig.pyright.setup(default_config)
lspconfig.tsserver.setup(default_config)
lspconfig.sumneko_lua.setup({
  on_attach = custom_on_attach,
  diagnostics = {
     -- Get the language server to recognize the `vim` global
    globals = {'vim'},
  }
})

lspconfig.eslint.setup{
  cmd = { "vscode-eslint-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue" },
  on_new_config = function(config, new_root_dir)
    config.settings.workspaceFolder = {
      uri = new_root_dir,
      name = vim.fn.fnamemodify(new_root_dir, ':t'),
    }
  end,
  settings = {
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = "separateLine"
      },
      showDocumentation = {
        enable = true
      }
    },
    codeActionOnSave = {
      enable = true,
      mode = "all"
    },
    format = false,
    nodePath = "",
    onIgnoredFiles = "off",
    packageManager = "npm",
    quiet = false,
    rulesCustomizations = {},
    run = "onType",
    useESLintClass = false,
    validate = "on",
    workingDirectory = {
      mode = "auto"
    }
  }
}

vim.g.completion_matching_strategy_list = {'substring', 'exact', 'fuzzy', 'all'}
vim.g.diagnostic_enable_virtual_text = 1
vim.g.diagnostic_insert_delay = 1
vim.g.completion_chain_complete_list = {
  {complete_items = {'lsp', 'snippet'}},
  {mode = '<c-p>'},
  {mode = '<c-n>'},
}
