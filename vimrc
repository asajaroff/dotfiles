" Galera's .vimrc file

set nocompatible

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
set number relativenumber

" Indenting
set autoindent
set smartindent
set shiftwidth=2

" Color Syntax
syntax on

" Tabbing options
set ts=2
set sts=2
set et

" Whitespaces (Activate with :set list)
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

" Powerline support
" set rtp+=/usr/lib/python3.7/site-packages/powerline/bindings/vim
let g:powerline_pycmd="py3"

" Filetype 
filetype plugin on

" Finding Files
" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

" Copy to macOS clipboard
vmap '' :w ! pbcopy<CR><CR>

" netrw Configuration
" Tree style directory view
let g:netrw_liststyle=3

" Remove banner 
let g:netrw_banner = 0

let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
