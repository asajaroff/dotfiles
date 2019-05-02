" Galera's .vimrc file

" Visual Bell
set visualbell

" Large status
set ruler
set laststatus=2

" Use case insensitive search, except when using capital letters.
set ignorecase
set smartcase

" Set all swap files to go to the same directory so they are not scattered everywhere.
set directory=~/.vim/swapfiles//
set backupdir=~/.vim/backupfiles//

" Set undo directory so undo persists outside of vim.
set undodir=~/.vim/undodir
set undofile

" Display line numbers on the left.
set number

" Indenting
set autoindent
set smartindent

" Color Syntax
syntax on

" Tabbing options
set ts=2
set sts=2
set et

" Powerline support
" set rtp+=/usr/lib/python3.7/site-packages/powerline/bindings/vim
let g:powerline_pycmd="py3"

