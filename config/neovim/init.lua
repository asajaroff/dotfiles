vim.lsp.set_log_level("debug")
require'lspconfig'.pyright.setup{}
require'lspconfig'.bashls.setup{}
require'lspconfig'.yamlls.setup{}
require'lspconfig'.gopls.setup {
  cmd = {"gopls", "serve"},
  filetypes = {'go'},
  settings = {
  gopls = {
    analyses = {
      unusedparams = true,
      },
      staticcheck = true,
    },
  },
}

