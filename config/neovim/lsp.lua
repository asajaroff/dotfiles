local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    require'lspconfig'[server].setup{}
  end
end

setup_servers()

-- Replace the default LSP diagnostic letters with prettier symbols
local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }

for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
vim.lsp.set_log_level("debug")
require'lspconfig'.pyright.setup{on_attach=require'completion'.on_attach}
require'lspconfig'.tflint.setup{on_attach=require'completion'.on_attach}
require'lspconfig'.cmake.setup{on_attach=require'completion'.on_attach}
require'lspconfig'.vimls.setup{on_attach=require'completion'.on_attach}
require'lspconfig'.cmake.setup{on_attach=require'completion'.on_attach}
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
