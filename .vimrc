" Galera's .vimrc file

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
