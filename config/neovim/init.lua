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

