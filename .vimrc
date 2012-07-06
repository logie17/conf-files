" set tabs widths
set tabstop=2
set shiftwidth=2
" use spaces
set expandtab
" colorscheme
set background=dark
colorscheme solarized
syntax enable
" highliting matched search
set hls
set autoindent
set confirm
set noincsearch
set wildmenu
set hlsearch
set showmode
set ruler

set title
set titleold=

set textwidth=78

set iskeyword+=$
set iskeyword+=%
set iskeyword+=@
set iskeyword-=,

setlocal spell spelllang=en_us

au BufNewFile,BufRead *.mh  setf mason
