" Plugins
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')
Plug 'amal-khailtash/vim-xdc-syntax'
Plug 'ayu-theme/ayu-vim'
Plug 'bronson/vim-trailing-whitespace'
Plug 'dcharbon/vim-flatbuffers'
Plug 'flazz/vim-colorschemes'
Plug 'gentoo/gentoo-syntax'
Plug 'junegunn/goyo.vim'
Plug 'lervag/vimtex'
Plug 'liuchengxu/graphviz.vim'
Plug 'lnl7/vim-nix'
Plug 'lotabout/skim', {'do':'./install'}
Plug 'lotabout/skim.vim'
Plug 'luochen1990/rainbow'
Plug 'majutsushi/tagbar'
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'nfnty/vim-nftables'
Plug 'potatoesmaster/i3-vim-syntax'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'qnighy/lalrpop.vim'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdtree'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'uarun/vim-protobuf'
Plug 'vhda/verilog_systemverilog.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'wellle/tmux-complete.vim'
call plug#end()

" Settings
" ---- Line numbers
set number
set cursorline
" ---- Hide files in the background instad of closing them
set hidden
" ---- Undo limit
set history=1000
" ---- Automatically re-read files if unmodified inside vim
set autoread
" ---- Leader
let mapleader = ","
let g:mapleader = ","
nmap <leader>w :w!<cr>
" ---- :W sudo-save file
command W w !sudo tee % > /dev/null
" ---- Filetype specific plugins and indentation rules
filetype plugin on
filetype indent on
" ---- Cursor lines
set so=10
" ---- Show cursor position
set ruler
" ---- Allow backspacing over indentation, line breaks, and insertion start
set backspace=eol,start,indent
" ---- Automatically wrap left and right
set whichwrap+=<,>,h,l,[,]
" ---- Ignore case when searching
set ignorecase
" ---- Make search case-sensitive when using uppercase letters
set smartcase
" ---- Search highlighting
set hlsearch
" ---- Incremental searches: show partial results
set incsearch
" ---- Turn off search highlighting
nnoremap <leader><space> :nohlsearch<CR>
" ---- Don't update screen during macro/script execution
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
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
" ---- UTF-8
set encoding=utf8
" ---- Unix filetypes
set ffs=unix,dos,mac
" ---- Spaces, never tabs
set expandtab
set smarttab
set shiftwidth=4
" ---- Linebreak at 80 chars
set lbr
set tw=80
" ---- Automatic indentation
set ai " Auto indent
set si " Smart indent
set wrap " Wrap lines
" ---- When in visual mode, * or # searches
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
" ---- Undo settings
try
    set undodir=~/.cache/undodir
    set undofile
catch
endtry
" ---- Set cursor to bar in tmux
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Plugin settings
" ---- luochen1990/rainbow
let g:rainbow_active = 1
" ---- lotabout/skim.vim
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
" ---- wellle/tmux-complete.vim
"let g:tmuxcomplete#trigger = ''
" ---- lervag/vimtex
let g:vimtex_compiler_latexmk = {
    \ 'options' : [
    \   '-pdf',
    \   '-shell-escape',
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_general_viewer = 'evince'

" ---- vim-airline/vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_highlighting_cache = 1
let g:airline#extensions#ale#enabled = 1
let g:airline_theme='ayu_dark'
" ---- nathanaelkane/vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
" ---- scrooloose/nerdtree
let g:NERDTreeWinPos = "left"
" ---- ayu-theme/ayu-vim
let ayucolor="dark"
colorscheme ayu
" ---- majutsushi/tagbar
noremap <leader>tb :TagbarToggle<CR>
" ---- neoclide/coc.vim
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? coc#rpc#request('doKeymap', ['snippets-expand-jump','']) :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'
