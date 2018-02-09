set encoding=utf-8
scriptencoding utf-8

" init {{{
augroup vimrc
  autocmd!
augroup END
" }}}

" key {{{
let g:mapleader = "\<Space>"

" buffer move
nnoremap <silent> <C-Left> :<C-u>bp<CR>
nnoremap <silent> <C-Right> :<C-u>bn<CR>

" exit from terminal insert mode
tnoremap <silent> <ESC> <C-\><C-n>

" ESC nohl
nnoremap <silent> <ESC><ESC> :<C-u>nohlsearch<CR>

" exit from help
autocmd vimrc FileType help nnoremap <buffer> q <C-w>c

" sudo save
cabbrev w!! w !sudo tee > /dev/null %

" indent
nnoremap <silent> <Tab> >>
nnoremap <silent> <S-Tab> <<
vnoremap <silent> <TAB> >gv
vnoremap <silent> <S-TAB> <gv

" window resize
nnoremap <silent> <A-h> <C-w><
nnoremap <silent> <A-l> <C-w>>
nnoremap <silent> <A-k> <C-w>+
nnoremap <silent> <A-j> <C-w>-

" toggle
nnoremap <silent> <Leader>m :<C-u>let &mouse=(&mouse == 'a' ? '' : 'a')<CR>:set mouse?<CR>
nnoremap <silent> <Leader>w :<C-u>setl wrap! wrap?<CR>
nnoremap <silent> <Leader>s :<C-u>call <SID>toggle_syntax()<CR>
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

" python {{{
function! s:pick_executable(pathspecs) abort
  for l:pathspec in filter(a:pathspecs, '!empty(v:val)')
    for l:path in reverse(glob(l:pathspec, 0, 1))
      if executable(l:path)
        return l:path
      endif
    endfor
  endfor
  return ''
endfunction

if has('nvim')
  let g:python_host_prog = s:pick_executable([
  \ '/usr/local/bin/python2',
  \ '/usr/bin/python2',
  \ '/bin/python2',
  \])
  let g:python3_host_prog = s:pick_executable([
  \ '/usr/local/bin/python3',
  \ '/usr/bin/python3',
  \ '/bin/python3',
  \])
endif
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

" set  {{{
filetype plugin indent on
syntax enable

set fileencodings=utf-8,cp932 fileformats=unix,dos
set smarttab expandtab tabstop=2 shiftwidth=2 softtabstop=2
set cursorline number nowrap
set list listchars=tab:>-,eol:↲,extends:»,precedes:«
set ambiwidth=double
set virtualedit=block
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
set splitbelow

set wildignore=*.pyc,*/__pycache__/,*.egg,*.egg-info/

autocmd vimrc QuickfixCmdPost make,grep,grepadd,vimgrep cwindow

autocmd vimrc BufReadPost /usr/include/c++/* if empty(&filetype) | set filetype=cpp | endif

autocmd vimrc InsertLeave * set nopaste

if has('persistent_undo')
  let &undodir = s:cache_home . '/undo'
  set undofile
  call mkdir(&undodir, 'p')
endif

if has('win32') || has('win64') || has('mac')
  set clipboard=unnamed
else
  set clipboard=unnamed,unnamedplus
endif
" }}}

set secure
