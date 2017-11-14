set encoding=utf-8
scriptencoding utf-8

" init {{{
augroup vimrc
  autocmd!
augroup END
" }}}

"dein {{{
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir . ',' . &runtimepath
let s:toml_file = fnamemodify(expand('<sfile>'), ':h').'/dein.toml'
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  call dein#load_toml(s:toml_file)
  call dein#end()
  call dein#save_state()
endif
if has('vim_starting') && dein#check_install()
  call dein#install()
endif
" }}}

" vimball {{{
let s:vimball_dir = s:cache_home . '/vimball'
let &runtimepath = s:vimball_dir . ',' . &runtimepath
"call mkdir(s:vimball_dir, 'p')
"packadd vimball
" }}}

" set  {{{
filetype plugin indent on
syntax enable

set fileencodings=utf-8,cp932 fileformats=unix,dos
set smarttab expandtab tabstop=2 shiftwidth=2 softtabstop=2
set cursorline number nowrap
set list listchars=tab:>-,eol:↲,extends:»,precedes:«
set ambiwidth=double
set virtualedit=block
"set clipboard=unnamedplus
set ignorecase smartcase incsearch
set wildmenu
set showmatch
set laststatus=2
set showcmd
set hidden
set mouse=a
set autoread
set autowrite
set scrolloff=3
set diffopt=filler,vertical

autocmd vimrc QuickfixCmdPost make,grep,grepadd,vimgrep cwindow

autocmd vimrc BufReadPost /usr/include/c++/* if empty(&filetype) | set filetype=cpp | endif

if has('persistent_undo')
  let &undodir = s:cache_home . '/undo'
  set undofile
  call mkdir(&undodir, 'p')
endif
" }}}

" key {{{
nnoremap [LEADER] <Nop>
nmap <Space> [LEADER]

nnoremap <silent> <F3> :<C-u>bp<CR>
nnoremap <silent> <F4> :<C-u>bn<CR>

tnoremap <silent> <ESC> <C-\><C-n>

nnoremap <silent> <S-Tab> <<
inoremap <silent> <S-Tab> <C-d>
vnoremap <silent> <TAB> >gv
vnoremap <silent> <S-TAB> <gv

nnoremap <silent> <S-Left> <C-w><
nnoremap <silent> <S-Right> <C-w>>
nnoremap <silent> <S-Up> <C-w>+
nnoremap <silent> <S-Down> <C-w>-

nnoremap <silent> <ESC><ESC> :<C-u>nohlsearch<CR>

autocmd vimrc FileType help nnoremap <buffer> q <C-w>c

cabbrev w!! w !sudo tee > /dev/null %

nnoremap <silent> [LEADER]m :<C-u>let &mouse=(&mouse == 'a' ? '' : 'a')<CR>:set mouse?<CR>
nnoremap <silent> [LEADER]w :<C-u>setl wrap! wrap?<CR>
nnoremap <silent> [LEADER]s :call <SID>toggle_syntax()<CR>
function! s:toggle_syntax() abort
  if exists('g:syntax_on')
    syntax off
    redraw
    echo 'syntax off'
  else
    syntax on
    redraw
    echo 'syntax on'
  endif
endfunction
" }}}
