set number
set relativenumber
set showcmd
set wildmenu
set expandtab
set smartindent
set smarttab
set nowrap
set tw=80 " document width
set ai
set lazyredraw " redraw only when needed
set showmatch " highlight matching braces
set cursorline " highlight cursorline

set foldenable
set foldlevelstart=10
set foldlevel=99
set foldnestmax=10

" set omnifunc=syntaxcomplete#Complete
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" inoremap <C-space> <C-x><C-i>

" {{{ Movement
" Select word by pressing space in normal mode
nmap <space> viw
" easier moving of code blocks
" Try to go into visual mode (v), thenselect several lines of code here and
" then press ``>`` several times.
vnoremap < <gv
vnoremap > >gv
" }}}

let mapleader=","       " leader is comma
" nnoremap <ESC> :nohlsearch<Return><ESC>
" noremap <esc> <esc>:noh<Return>
nmap <F4> :noh<Return>
imap <c-u> <esc>viwUi
cmap w!! %!sudo tee > /dev/null %

" Commenting blocks of code{{{

autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
autocmd FileType sh,ruby,python   let b:comment_leader = '# '
autocmd FileType conf,fstab       let b:comment_leader = '# '
autocmd FileType tex              let b:comment_leader = '% '
autocmd FileType mail             let b:comment_leader = '> '
autocmd FileType vim              let b:comment_leader = '" '
autocmd FileType lua              let b:comment_leader = '-- '
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

" }}}

"   {{{ Abbreviations
iabbrev @@ vitis130@gmail.com
iabbrev ccopy Copyright 2017 Vít Štěpánek, all rights reserved.
" }}}

" {{{ Backups
" 
" set backup
" set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
" set backupskip=/tmp/*,/private/tmp/*
" set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
" set writebackup
" 
" }}} 

set incsearch " search as typing
set hlsearch " highlight matches
filetype detect
" filetype plugin on
filetype plugin indent on
syntax on
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Persistent undo per file that persists per sessions
if has("persistent_undo")
    set undodir=~/.vim/undodir
    set undofile
endif

" access system clipboard
set clipboard=unnamed

set nocompatible
set encoding=utf8
" setlocal foldmethod=syntax
set foldmethod=marker
colorscheme mushroom
" colorscheme default
" colorscheme vim-distinguished
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview 
