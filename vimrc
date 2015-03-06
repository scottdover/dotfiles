"==============================================================================
" Plugins
"==============================================================================

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'gmarik/Vundle.vim'

" General
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-unimpaired'

" Colors
Plugin 'godlygeek/csapprox'
Plugin 'morhetz/gruvbox'
Plugin 'chriskempson/base16-vim'
Plugin 'w0ng/vim-hybrid'
Plugin 'vim-scripts/darkspectrum'

" Status
Plugin 'bling/vim-airline'

" Files and directories
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'kien/ctrlp.vim'

" Formatting
Plugin 'tomtom/tcomment_vim'
Plugin 'godlygeek/tabular'
Plugin 'tpope/vim-surround'

" Movement
Plugin 'terryma/vim-multiple-cursors'
Plugin 'Lokaltog/vim-easymotion'

" Programming
Plugin 'scrooloose/syntastic'
Plugin 'rayburgemeestre/phpfolding.vim'

" Git
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'

call vundle#end()

"==============================================================================
" Environment Settings
"==============================================================================

set t_Co=256
set background=dark
set guifont=Meslo_LG_S_Regular_for_Powerline:h12

" Set up theme
colorscheme gruvbox
autocmd BufReadPost * highlight Comment cterm=none

set clipboard=unnamed           " Use the system clipboard

set expandtab                   " Tab key inserts spaces
set softtabstop=4               " Use 4 spaces for indentation
set shiftwidth=4                " Use 4 spaces for indentation

set ignorecase                  " Default to case insensitive searches
set smartcase                   " Unless uppercase letters are present
set hlsearch                    " Highlight searches
set incsearch                   " Search while typing

set wrap                        " Wrap lines
set scrolloff=3                 " Pad the cursor with 3 lines
set scrolljump=5                " Scroll by 5 lines
set number                      " Show line numbers
set relativenumber              " Relative to the current line
silent! set colorcolumn=80      " Draw right margin at 80 characters

set list                        " Enable hidden characters
set listchars=tab:▷·            " Show tab characters
set listchars+=trail:·          " Show trailing spaces

set wildmode=longest,list       " Make completion mode acts like Bash

set showcmd                     " Show incomplete normal mode commands
set noshowmode                  " Hide current mode

set directory^=~/.backup//      " Write swap files to ~/.backup

set visualbell t_vb=            " Be quiet

"==============================================================================
" Mappings
"==============================================================================

let mapleader="\\"

" Prevent p from replacing the buffer (copy what was originally selected)
vnoremap p pgvy

" Make Y yank to end of line
nnoremap Y y$

" Preserve selection on indent
vnoremap < <gv
vnoremap > >gv

" Create a new tab
nnoremap <Tab><Enter> :tabedit<Space>

" Move to previous and next tabs
nnoremap <silent> [<Tab> :tabprev<CR>
nnoremap <silent> ]<Tab> :tabnext<CR>

" Move tabs left or right
nnoremap <silent> g{ :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> g} :execute 'silent! tabmove ' . tabpagenr()<CR>

" Jump back and forth between Git hunks
nnoremap ]h :GitGutterNextHunk<CR>
nnoremap [h :GitGutterPrevHunk<CR>

" Yank to shared clipboard
noremap <silent> gy :w! ~/.clipboard<CR>:echo 'Selection written to ~/.clipboard'<CR>

" Align delimiting characters
noremap <silent> <Leader>a= :Tabularize /=<CR>
noremap <silent> <Leader>a> :Tabularize /=><CR>
noremap <silent> <Leader>a: :Tabularize /:<CR>

" Toggle NERD Tree
nnoremap <silent> <Leader>nt :NERDTreeTabsToggle<CR>
nnoremap <silent> <Leader>nf :NERDTreeFind<CR>

" Kill all line numbers to enable copy over SSH
nnoremap <silent> <Leader>con :set nonumber<CR>:set norelativenumber<CR>:sign unplace *<CR>

"==============================================================================
" Commands
"==============================================================================

" File system helpers
command Mkdir !mkdir -p %:h > /dev/null
command SudoWrite write !sudo tee % > /dev/null

"==============================================================================
" Plugin Settings
"==============================================================================

let g:nerdtree_tabs_open_on_gui_startup=0

let g:ctrlp_cmd='CtrlPMixed'
let g:ctrlp_user_command={
    \ 'types': {
        \ 1: ['.git', 'cd %s && git ls-files'],
        \ },
    \ 'fallback': 'find %s -type f',
    \ }
let g:ctrlp_custom_ignore = 'Proxy\|vendor\|cache'

let g:airline_powerline_fonts=1

let g:syntastic_mode_map={
    \ 'mode': 'active',
    \ 'active_filetypes': [],
    \ 'passive_filetypes': [],
    \ }
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1
let g:syntastic_quiet_messages={ 'type': 'style' }
let g:syntastic_enable_signs=1
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='!'

let g:gist_post_private=1

"==============================================================================
" Auto Commands
"==============================================================================

augroup vimrc

" Clear existing commands in this group
autocmd!

" Show absolute line numbers in insert mode
autocmd InsertEnter * set number norelativenumber
autocmd InsertLeave * set number relativenumber

" Highlight lines with more than 120 characters
autocmd BufWinEnter * let w:m3=matchadd('ErrorMsg', '\%>120v.\+', -1)

" Disable whitespace at the end of comments
autocmd FileType * setlocal formatoptions-=w

" Strip whitespace when saving certain types of files
autocmd FileType php autocmd BufWritePre <buffer> :%s/\s\+$//e

" Jump to the last cursor position when opening a file
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Always start at the top of a commit message
autocmd FileType gitcommit autocmd! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

" Open the quickfix window with grep results
autocmd QuickFixCmdPost *grep* cwindow

augroup END

"==============================================================================
" Local Configurations
"==============================================================================

if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif
