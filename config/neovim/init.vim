" Galera's .vimrc file

"" Plugins
source ~/.dotfiles/config/neovim/plugins.vim

" Live Substitution
set inccommand=split

" Highlight yanked text
augroup LuaHighlight
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

" Using lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

set nocompatible

" Scroll related
set scrolloff=2 " determines the number of context lines you would like to see above and below the cursor

" Visual Bell
set visualbell

" Large status
set ruler
set laststatus=2

" Use case insensitive search, except when using capital letters.
set ignorecase
set smartcase

" Set all swap files to go to the same directory so they are not scattered everywhere.
set directory=~/.vim/swapfiles
set backupdir=~/.vim/backupfiles

" Set undo directory so undo persists outside of vim.
set undodir=~/.vim/undodir
set undofile

" Display line numbers on the left.
set number relativenumber

" Line limit
setlocal colorcolumn=80

" Indenting
set autoindent
set smartindent
set shiftwidth=2

" Color Syntax
syntax off
highlight LspDiagnosticsVirtualTextError guifg=Red ctermfg=Red

" Tabbing options
set ts=2
set sts=2
set et

" Whitespaces (Activate with :set list)
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

" Filetype 
filetype plugin on

" Finding Files
" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**/*

" Search
set incsearch

" netrw Configuration
" Tree style directory view
" let g:netrw_liststyle=3

" Remove banner 
" let g:netrw_banner = 0
" let g:netrw_browse_split = 2
" let g:netrw_altv = 1
" let g:netrw_winsize = 50

" Panes managment
" Open new split panes to right and bottom
set splitbelow
set splitright

" Launch gopls when Go files are in use
let g:LanguageClient_serverCommands = {
       \ 'go': ['gopls'],
       \ 'python': ['pyright']
       \ }
" Run gofmt on save
autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()

" lua Imports
luafile ${HOME}/.dotfiles/config/neovim/init.lua
luafile ${HOME}/.dotfiles/config/neovim/lsp.lua
luafile ${HOME}/.dotfiles/config/neovim/treesitter.lua
luafile ${HOME}/.dotfiles/config/neovim/lualine.lua

" Post init imports

source ~/.dotfiles/config/neovim/nvimtree.vim

" Post Start
let g:LanguageClient_serverCommands = {
    \ 'sh': ['bash-language-server', 'start'],
    \ 'yaml': ['yaml-language-server', '--stdio'],
    \ 'go': ['gopls', '--serve']
    \ }

"" Completion
" https://github.com/nvim-lua/completion-nvim
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" possible value: 'UltiSnips', 'Neosnippet', 'vim-vsnip', 'snippets.nvim'
let g:completion_enable_snippet = 'UltiSnips'
let g:completion_matching_smart_case = 1
"" TODO: Test snippets.nvim

" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/nvim-lua/completion-nvim
" let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" Spelling
" setlocal spell spelllang=en_us
