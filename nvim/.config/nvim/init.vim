set encoding=utf-8
scriptencoding utf-8

" init {{{
augroup vimrc
  autocmd!
augroup END
" }}}

" key {{{
let g:mapleader = "\<Space>"

" exit from terminal insert mode
tnoremap <ESC> <C-\><C-n>

" ESC nohl
nnoremap <silent> <ESC><ESC> :<C-u>nohlsearch<CR>

" exit from help
autocmd vimrc FileType help nnoremap <buffer> q <C-w>c

" sudo save
cabbrev w!! w !sudo tee > /dev/null %

" open {}
nnoremap <Leader>o ^f{a<CR><CR><UP>

" indent
vnoremap <TAB> >gv
vnoremap <S-TAB> <gv

" copy mouse selection
vnoremap <LeftRelease> y<CR>gv<LeftRelease>

" window resize
nnoremap <A-h> <C-w><
nnoremap <A-l> <C-w>>
nnoremap <A-k> <C-w>+
nnoremap <A-j> <C-w>-

" register
nnoremap <Leader>d "_d

" quick replace
nnoremap <Leader>rr :%s/\<<C-r><C-w>\>//g<Left><Left>

" toggle
nnoremap <Leader>m :<C-u>let &mouse=(&mouse == 'a' ? '' : 'a')<CR>:set mouse?<CR>
nnoremap <Leader>w :<C-u>setl wrap! wrap?<CR>
nnoremap <Leader>s :<C-u>call <SID>toggle_syntax()<CR>
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
  \ '~/.linuxbrew/bin/python2',
  \ '/usr/local/bin/python2',
  \ '/usr/bin/python2',
  \ '/bin/python2',
  \])
  let g:python3_host_prog = s:pick_executable([
  \ '~/.linuxbrew/bin/python3',
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
set matchpairs& matchpairs+=<:>
set laststatus=2
set showcmd
set hidden
set mouse=a
set autoread
set autowrite
set scrolloff=3
set diffopt=filler,vertical
set splitbelow
set showbreak=↳\ 

autocmd vimrc InsertLeave * set nopaste

autocmd vimrc FileType * setlocal formatoptions-=ro

autocmd vimrc BufNewFile,BufRead *.tmux setfiletype tmux
autocmd vimrc BufNewFile,BufRead *.gitconfig.* setfiletype gitconfig
autocmd vimrc BufNewFile,BufRead *.nspawn setfiletype systemd
autocmd vimrc BufNewFile,BufRead .clang-tidy,.clang-format setfiletype yaml
autocmd vimrc BufNewFile,BufRead *.pbtxt setfiletype proto

" https://vim-jp.org/vim-users-jp/2011/02/20/Hack-202.html
augroup vimrc-auto-mkdir  " {{{
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)  " {{{
    if !isdirectory(a:dir) && a:dir !~? '^[^:]*://'  && (a:force || input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction  " }}}
augroup END  " }}}

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
