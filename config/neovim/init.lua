vim.lsp.set_log_level("debug")
require'lspconfig'.pyright.setup{on_attach=require'completion'.on_attach}
require'lspconfig'.bashls.setup{on_attach=require'completion'.on_attach}
require'lspconfig'.yamlls.setup{on_attach=require'completion'.on_attach}
require'lspconfig'.html.setup{on_attach=require'completion'.on_attach}
require'lspconfig'.gopls.setup{
  on_attach=require'completion'.on_attach,
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
-- Treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "bash", "python", "c", "cpp", "cmake", "css", "dockerfile", "go", "gomod", "graphql", "hcl", "java", "javascript", "typescript", "json", "toml", "vim", "vue", "yaml"
  },
  highlight = {
    enable = true,
  highlight = {
    enable = true,              -- false will disable the whole extension
    additional_vim_regex_highlighting = true,
  },
}
