call plug#begin('~/.vim/plugged')

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Treesitter ?
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

" Language Server Protocol
Plug 'neovim/nvim-lspconfig'

" Autocomplete
Plug 'nvim-lua/completion-nvim'

" Snippets

" Chetadas
Plug 'kyazdani42/nvim-web-devicons'

call plug#end()
