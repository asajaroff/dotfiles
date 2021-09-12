call plug#begin('~/.vim/plugged')

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Treesitter ?
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

" Language Server Protocol
Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'

" Autocomplete
Plug 'nvim-lua/completion-nvim'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" tree
Plug 'kyazdani42/nvim-tree.lua'

" Fonts
" Nerd Fonts: https://www.nerdfonts.com/font-downloads
Plug 'kyazdani42/nvim-web-devicons'

" Chetadas
Plug 'hoob3rt/lualine.nvim'
Plug 'romgrk/barbar.nvim'

call plug#end()
