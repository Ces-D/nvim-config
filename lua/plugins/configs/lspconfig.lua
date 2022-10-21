local present, lspconfig = pcall(require, "lspconfig")
local installPresent, masoninstaller = pcall(require, "mason")

if not (present and installPresent) then
  return
end

local function custom_on_attach(client)
  vim.notify('Attaching to ' .. client.name)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- vim.lsp.set_log_level("debug")
-- INSTALLER SETUP
masoninstaller.setup {
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
}

-- PYTHON SETUP
lspconfig.pyright.setup({
  on_attach = custom_on_attach,
  capabilites = capabilities
})

-- TS AND JS SETUP
lspconfig.tsserver.setup({
  on_attach = custom_on_attach,
  filetypes = { 'typescript', 'typescriptreact', 'typescript.tsx' },
  capabilities = capabilities
})

-- LUA SETUP
lspconfig.sumneko_lua.setup({
  on_attach = custom_on_attach,
  capabilities = capabilities,
  diagnostics = {
    -- Get the language server to recognize the `vim` global
    globals = { 'vim' },
  }
})

-- RUST SETUP
lspconfig.rust_analyzer.setup({
  on_attach = custom_on_attach
})

--  capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.jsonls.setup {
  capabilities = capabilities
}

vim.g.completion_matching_strategy_list = { 'substring', 'exact', 'fuzzy', 'all' }
vim.g.diagnostic_enable_virtual_text = 1
vim.g.completion_chain_complete_list = {
  { complete_items = { 'lsp', 'snippet' } },
  { mode = '<c-p>' },
  { mode = '<c-n>' },
}
