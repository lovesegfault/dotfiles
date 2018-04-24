" Plugins --------------------------------------------------------------------
call plug#begin('~/.local/share/nvim/plugged')
Plug 'autozimu/LanguageClient-neovim', {
            \ 'branch': 'next',
            \ 'do': 'bash install.sh',
            \ }
Plug 'junegunn/fzf'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-clang'
Plug 'sebastianmarkow/deoplete-rust'
Plug 'zchee/deoplete-jedi'
Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'fszymanski/deoplete-emoji'
Plug 'wellle/tmux-complete.vim'
Plug 'wokalski/autocomplete-flow'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'scrooloose/nerdtree'
Plug 'w0rp/ale'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdcommenter'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'mattn/gist-vim'
Plug 'fatih/vim-go'
Plug 'python-mode/python-mode', { 'branch': 'develop' }
Plug 'rust-lang/rust.vim'
Plug 'flazz/vim-colorschemes'
Plug 'terryma/vim-multiple-cursors'
Plug 'bronson/vim-trailing-whitespace'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'ervandew/supertab'
Plug 'lervag/vimtex'
Plug 'potatoesmaster/i3-vim-syntax'
Plug 'cespare/vim-toml'
Plug 'elzr/vim-json'
Plug 'salinasv/vim-vhdl'
Plug 'vim-scripts/ucf.vim'
Plug 'vim-scripts/c.vim'
call plug#end()
" General --------------------------------------------------------------------
set number
set hidden
set history=1000
set autoread

let mapleader = ","
let g:mapleader = ","
nmap <leader>w :w!<cr>

" :W sudo saves file
command W w !sudo tee % > /dev/null

filetype plugin on
filetype indent on


set so=10 " Cursor lines
set ruler
set hid
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Search options
set ignorecase
set smartcase
set hlsearch
set incsearch

set lazyredraw "Performance
set magic "Magic macros
set showmatch "Matching brackets

" Removes bells on error
set noerrorbells
set novisualbell

" Syntax highlighting, truecolors
syntax enable
"set termguicolors

" UTF8 and UNIX filetypes
set encoding=utf8
set ffs=unix,dos,mac

" Use spaces, not tabs
set expandtab
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" When in visual, pressing * or # searches
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>

" Moving between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all buffers
map <leader>ba :bufdo bd<cr>

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>t<leader> :tabnext<cr>

" tl toggles tabs alt-tab style
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
    set switchbuf=useopen,usetab,newtab
    set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


try
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry

" ----------------------------------------------------------------------------
let g:LanguageClient_serverCommands = {
            \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
            \ 'javascript': ['javascript-typescript-stdio'],
            \ 'javascript.jsx': ['javascript-typescript-stdio'],
            \ }

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

" Use deoplete.
let g:deoplete#enable_at_startup = 1

let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/clang'
let g:deoplete#sources#clang#sort_algo = 'priority'

let g:deoplete#sources#rust#racer_binary = '/home/bemeurer/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path = '/usr/src/rust/src/'

let g:deoplete#sources#go#gocode_binary = '/usr/bin/gocode'

let g:ale_sign_column_always = 1

let g:tmuxcomplete#trigger = ''

let g:neosnippet#enable_completed_snippet = 1

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_highlighting_cache = 1
let g:airline#extensions#ale#enabled = 1
let g:airline_theme='cobalt2'

let g:pymode_python = 'python3'

let g:indent_guides_enable_on_vim_startup = 1

let  g:C_UseTool_cmake = 'yes'
let  g:C_UseTool_doxygen = 'yes'

let g:NERDTreeWinPos = "left"

colorscheme cobalt2
