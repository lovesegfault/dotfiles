" Plugins --------------------------------------------------------------------
call plug#begin('~/.local/share/nvim/plugged')
" ---- LSP
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'autozimu/LanguageClient-neovim', {
            \ 'branch': 'next',
            \ 'do': 'make release',
            \ }
" ---- Git
Plug 'tpope/vim-fugitive'
" --- Completion/intellisense
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-clang'
Plug 'zchee/deoplete-jedi'
Plug 'juliaeditorsupport/deoplete-julia'
Plug 'wellle/tmux-complete.vim'
Plug 'ervandew/supertab'
" ---- Snippets
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
" ---- File browser
Plug 'scrooloose/nerdtree'
" ---- Linting
Plug 'w0rp/ale'
" ---- Brackets
Plug 'luochen1990/rainbow'
Plug 'tpope/vim-surround'
" ---- Statusbar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" ---- Indentation
Plug 'nathanaelkane/vim-indent-guides'
Plug 'godlygeek/tabular'
" ---- Gists
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
" ---- Languages
Plug 'python-mode/python-mode', { 'branch': 'develop' }
Plug 'rust-lang/rust.vim'
Plug 'qnighy/lalrpop.vim'
Plug 'potatoesmaster/i3-vim-syntax'
Plug 'cespare/vim-toml'
Plug 'elzr/vim-json'
Plug 'salinasv/vim-vhdl'
Plug 'vim-scripts/ucf.vim' " Xilinx User Constraint Files
Plug 'vim-scripts/c.vim' " Modern C
Plug 'julialang/julia-vim'
Plug 'plasticboy/vim-markdown'
Plug 'lervag/vimtex' " LaTeX IDE
Plug 'lnl7/vim-nix'
Plug 'gentoo/gentoo-syntax'
Plug 'sukima/xmledit'
Plug 'nfnty/vim-nftables'
Plug 'derekelkins/agda-vim'
" ---- Utils
Plug 'junegunn/goyo.vim'
Plug 'flazz/vim-colorschemes'
Plug 'terryma/vim-multiple-cursors'
Plug 'bronson/vim-trailing-whitespace'
call plug#end()
" General --------------------------------------------------------------------
" ---- Line numbers
set number
set cursorline
" ---- Hide files in the background instead of closing them.
set hidden
" ---- Undo limit
set history=1000
" ---- Automatically re-read files if unmodified inside Vim.
set autoread

" --- Leader
let mapleader = ","
let g:mapleader = ","
nmap <leader>w :w!<cr>

" ---- :W sudo saves file
command W w !sudo tee % > /dev/null

" ---- Filetype specific plugins and indentation rules
filetype plugin on
filetype indent on

" ---- Cursor lines
set so=10
" ---- Show cursor position
set ruler
" ---- Allow backspacing over indention, line breaks and insertion start
set backspace=eol,start,indent
" ---- Automatically wrap left and right
set whichwrap+=<,>,h,l,[,]

" ---- Ignore case when searching
set ignorecase
" ---- Make search case-sensitive when using uppercase letters
set smartcase
" ---- Search highlighting
set hlsearch
" ---- Incremental searches, show partial results
set incsearch

" ---- Don't update screen during macro/script execution, for performance
set lazyredraw
" ---- Enable magic macros
set magic
" ---- Show matching brackets
set showmatch

" ---- No bells on errors
set noerrorbells
set novisualbell

" ---- Syntax highlighting
syntax enable
" ---- True colors
" set termguicolors

" ---- UTF8
set encoding=utf8
" ---- UNIX filetypes
set ffs=unix,dos,mac

" ---- Use spaces, not tabs
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

" ---- Linebreak on 500 characters
set lbr
set tw=120

" ---- Automatic indentation
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" ---- When in visual, pressing * or # searches
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>

" ---- Moving between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" ---- Close the current buffer
map <leader>bd :bd<cr>:tabclose<cr>gT

" ---- Close all buffers
map <leader>ba :bufdo bd<cr>

" ---- Next/Previous buffer
map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" ---- Managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>t<leader> :tabnext<cr>

" ---- tl toggles tabs alt-tab style
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" ---- Opens a new tab with the current buffer's path
" -- Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" ---- Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" ---- Specify the behavior when switching between buffers
try
    set switchbuf=useopen,usetab,newtab
    set stal=2
catch
endtry

" ---- Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


" ---- Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" ---- Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=
noremap <leader>f :RustFmt <CR>

xnoremap π "_dP
try
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry

" Plugin settings -------------------------------------------------------------
" ---- Rainbow brackets
let g:rainbow_active = 1

" ---- fzf
let g:fzf_layout = { 'window': '60split enew' }
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
nnoremap <C-b> :Buffers<CR>
nnoremap <C-p> :Files<CR>

set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
command -nargs=+ -complete=file -bar Rg silent! grep! <args>|cwindow|redraw!

" ---- Ctrl+P search with ripgrep
let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
let g:ctrlp_user_caching = 0

" ---- LSP server commands
let g:LanguageClient_serverCommands = {
            \ 'rust': ['rls'],
            \ 'c': ['/usr/lib/llvm/7/bin/clangd'],
            \ 'cpp': ['/usr/lib/llvm/7/bin/clangd'],
            \ }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

" ---- Deoplete
let g:deoplete#enable_at_startup = 1

let g:deoplete#sources#clang#libclang_path = '/usr/lib64/llvm/7/lib64/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib64/llvm/7/bin/clang'
let g:deoplete#sources#clang#sort_algo = 'priority'

" let g:deoplete#sources#go#gocode_binary = '/usr/bin/gocode'

let g:ale_completion_enabled = 0
let g:ale_sign_column_always = 1
let g:ale_rust_cargo_use_check = 1
let g:ale_rust_cargo_check_tests = 1
let g:ale_rust_cargo_check_examples = 1

" -- Deoplete doesn't need a trigger
let g:tmuxcomplete#trigger = ''

let g:neosnippet#enable_completed_snippet = 1

" ---- VimTeX
let g:vimtex_view_method = 'zathura'
let g:vimtex_compiler_progname = 'nvr'

" ---- Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_highlighting_cache = 1
let g:airline#extensions#ale#enabled = 1
let g:airline_theme='cobalt2'

" ---- Use Python 3
let g:pymode_python = 'python3'

" ---- Enable indent guides
let g:indent_guides_enable_on_vim_startup = 1

" ---- Always open NERD Tree on the left
let g:NERDTreeWinPos = "left"

" ---- Make supertab go top->bottom
let g:SuperTabDefaultCompletionType = "<c-n>"

" ---- Deoplete fix for vim-multiple-cursors
func! Multiple_cursors_before()
  if deoplete#is_enabled()
    call deoplete#disable()
    let g:deoplete_is_enable_before_multi_cursors = 1
  else
    let g:deoplete_is_enable_before_multi_cursors = 0
  endif
endfunc
func! Multiple_cursors_after()
  if g:deoplete_is_enable_before_multi_cursors
    call deoplete#enable()
  endif
endfunc
" ---- Theme
colorscheme cobalt2
