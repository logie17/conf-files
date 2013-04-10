"~~~General Vim Settings~~~
"
" set tabs widths
set tabstop=2
set shiftwidth=2
" use spaces
set expandtab
" colorscheme
set background=dark
" colorscheme solarized
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

set textwidth=0

set iskeyword+=$
set iskeyword+=%
set iskeyword+=@
set iskeyword-=,

setlocal spell spelllang=en_us
filetype plugin on

map <C-T> <Esc>:tabnew<CR>
map <C-S> <Esc>:set expandtab<CR>
map <C-Tab> <Esc>:set noexpandtab<CR>
map <C-c> :s/^/#/
                
"Allows perlbrew to work
if filereadable($HOME . "/perl5/perlbrew/etc/bashrc")
  let $PATH=system("source " . $HOME . "/perl5/perlbrew/etc/bashrc; echo -n $PATH")
endif

"~~~Plugin Settings Below~~~
"Project settings
let g:proj_flags="imstvcg"

"Pathogen settings
call pathogen#infect()

"Fugitive Settings
"Set branch name in status line
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
"Delete unused fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete

"~~~Random Functions Below~~~
" Return indent (all whitespace at start of a line), converted from
" tabs to spaces if what = 1, or from spaces to tabs otherwise.
" When converting to tabs, result has no redundant spaces.
function! Indenting(indent, what, cols)
  let spccol = repeat(' ', a:cols)
  let result = substitute(a:indent, spccol, '\t', 'g')
  let result = substitute(result, ' \+\ze\t', '', 'g')
  if a:what == 1
    let result = substitute(result, '\t', spccol, 'g')
  endif
  return result
endfunction

" Convert whitespace used for indenting (before first non-whitespace).
" what = 0 (convert spaces to tabs), or 1 (convert tabs to spaces).
" cols = string with number of columns per tab, or empty to use 'tabstop'.
" The cursor position is restored, but the cursor will be in a different
" column when the number of characters in the indent of the line is changed.
function! IndentConvert(line1, line2, what, cols)
  let savepos = getpos('.')
  let cols = empty(a:cols) ? &tabstop : a:cols
  execute a:line1 . ',' . a:line2 . 's/^\s\+/\=Indenting(submatch(0), a:what, cols)/e'
  call histdel('search', -1)
  call setpos('.', savepos)
endfunction

command! -nargs=? -range=% Space2Tab call IndentConvert(<line1>,<line2>,0,<q-args>)
command! -nargs=? -range=% Tab2Space call IndentConvert(<line1>,<line2>,1,<q-args>)
command! -nargs=? -range=% RetabIndent call IndentConvert(<line1>,<line2>,&et,<q-args>)

