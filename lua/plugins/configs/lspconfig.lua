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
masoninstaller.setup {}

-- PYTHON SETUP
--lspconfig.pyright.setup({
--  on_attach = custom_on_attach,
--  capabilites = capabilites
-- })

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

-- ESLINT SETUP
-- lspconfig.eslint.setup {
--   cmd = { "vscode-eslint-language-server", "--stdio" },
--   filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx",
--     "vue" },
--   settings = {
--     codeAction = {
--       disableRuleComment = {
--         enable = true,
--         location = "separateLine"
--       },
--       showDocumentation = {
--         enable = true
--       }
--     },
--     codeActionOnSave = {
--       enable = true,
--       mode = "all"
--     },
--     format = true,
--     nodePath = "",
--     onIgnoredFiles = "off",
--     packageManager = "npm",
--     quiet = false,
--     rulesCustomizations = {},
--     run = "onType",
--     useESLintClass = false,
--     validate = "on",
--     workingDirectory = {
--       mode = "location"
--     }
--   }
-- }
--
--  capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.jsonls.setup {
  --   capabilities = capabilities
}

vim.g.completion_matching_strategy_list = { 'substring', 'exact', 'fuzzy', 'all' }
vim.g.diagnostic_enable_virtual_text = 1
vim.g.completion_chain_complete_list = {
  { complete_items = { 'lsp', 'snippet' } },
  { mode = '<c-p>' },
  { mode = '<c-n>' },
}
