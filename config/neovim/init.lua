-- lualine
require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'nord',
    component_separators = {'', ''},
    section_separators = {'', ''},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}

local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    require'lspconfig'[server].setup{}
  end
end

setup_servers()

-- Replace the default LSP diagnostic letters with prettier symbols
vim.fn.sign_define("LspDiagnosticsSignError", {text = "E", numhl = "LspDiagnosticsDefaultError"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "W", numhl = "LspDiagnosticsDefaultWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "I", numhl = "LspDiagnosticsDefaultInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "H", numhl = "LspDiagnosticsDefaultHint"})

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
-- Treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "bash", "python", "c", "cpp", "cmake", "css", "dockerfile", "go", "gomod", 
    "graphql", "hcl", "java", "javascript", "typescript", "json", "toml", 
    "vim", "vue", "yaml"
  },
  highlight = {
    enable = true,
  highlight = {
    enable = true,              -- false will disable the whole extension
    additional_vim_regex_highlighting = true,
    },
  } 
}

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.jsonc.used_by = "json"
parser_config.markdown = {
  install_info = {
    url = "https://github.com/ikatyang/tree-sitter-markdown",
    files = { "src/parser.c", "src/scanner.cc" },
  },
}

