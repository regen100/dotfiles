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

" plugin {{{
let s:vimplug = has('nvim') ? stdpath('config') . '/autoload/plug.vim' : expand('~/.vim/autoload/plug.vim')
let s:vimplug_install = 0
if !filereadable(s:vimplug)
  if !executable('curl')
    echoerr 'You have to install curl'
    execute 'cq!'
  endif
  if !executable('git')
    echoerr 'You have to install git'
    execute 'cq!'
  endif
  echo 'Installing vim-plug... ' . s:vimplug
  echo ''
  silent execute '!curl -fLo ' . s:vimplug . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  if v:shell_error != 0
    echoerr 'Failed'
    execute 'cq!'
  endif
  let s:vimplug_install = 1
endif
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

if !exists('g:vscode')
  Plug 'w0ng/vim-hybrid'
  Plug 'sheerun/vim-polyglot'
    let g:cpp_class_scope_highlight = 1
    let g:cpp_member_variable_highlight = 1
    let g:cpp_class_decl_highlight = 1
    let g:cpp_experimental_simple_template_highlight = 1
    let g:cpp_concepts_highlight = 1
    let g:cpp_no_function_highlight = 1
    let g:vim_json_syntax_conceal = 0
    let g:vim_markdown_conceal = 0
    autocmd vimrc BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css
  Plug 'Yggdroot/indentLine'
    let g:indentLine_fileTypeExclude = ['help', 'tagbar', 'git', '']
  Plug 'lilydjwg/colorizer'
  Plug 'junegunn/rainbow_parentheses.vim'
    let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
    autocmd vimrc FileType cpp RainbowParentheses
  Plug 'thinca/vim-zenspace'
  Plug 'bronson/vim-trailing-whitespace'
    autocmd vimrc BufWritePre * FixWhitespace
  Plug 'itchyny/vim-cursorword'
  Plug 'tpope/vim-unimpaired'
  if executable('fzf')
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
      noremap <Leader>e :<C-u>Files<CR>
      noremap <Leader>b :<C-u>Buffers<CR>
      if has('nvim')
        tnoremap <expr> <Esc> (&filetype == 'fzf') ? '<Esc>' : '<c-\><c-n>'
      endif
  endif
  Plug 'lambdalisue/suda.vim'
    cabbrev w!! SudaWrite
endif
Plug 'tpope/vim-repeat'
if exists('g:vscode')
  Plug 'asvetliakov/vim-easymotion', {'as': 'vim-easymotion_vscode'}
else
  Plug 'easymotion/vim-easymotion'
endif
  let g:EasyMotion_use_migemo = 1
  nmap s <Plug>(easymotion-s2)
  xmap s <Plug>(easymotion-s2)
if exists('g:vscode')
  xmap gc <Plug>VSCodeCommentary
  nmap gc <Plug>VSCodeCommentary
  omap gc <Plug>VSCodeCommentary
  nmap gcc <Plug>VSCodeCommentaryLine
else
  Plug 'tpope/vim-commentary'
endif

call plug#end()
if s:vimplug_install || exists('g:force_install')
  PlugInstall --sync
endif
" }}}

" set {{{
set ignorecase smartcase incsearch

if !exists('g:vscode')
  filetype plugin indent on
  syntax enable

  if &t_Co >= 256
    set background=dark
    colorscheme hybrid
  endif

  set ambiwidth=double
  set autoread
  set autowrite
  set cmdheight=2
  set cursorline number nowrap
  set diffopt=filler,vertical
  set fileencodings=utf-8,cp932 fileformats=unix,dos
  set hidden
  set laststatus=2
  set list listchars=tab:>-,eol:↲,extends:»,precedes:«
  set matchpairs& matchpairs+=<:>
  set mouse=a
  set scrolloff=3
  set showbreak=↳\
  set showcmd
  set showmatch
  set smarttab expandtab tabstop=2 shiftwidth=2 softtabstop=2
  set splitbelow
  set updatetime=300
  set virtualedit=block
  set wildmenu
  set termguicolors
  set pumblend=30

  autocmd vimrc InsertLeave * set nopaste

  autocmd vimrc FileType * setlocal formatoptions-=ro

  autocmd vimrc BufNewFile,BufRead *.tmux setfiletype tmux
  autocmd vimrc BufNewFile,BufRead *.gitconfig.* setfiletype gitconfig
  autocmd vimrc BufNewFile,BufRead *.nspawn setfiletype systemd
  autocmd vimrc BufNewFile,BufRead .clang-tidy,.clang-format setfiletype yaml
  autocmd vimrc BufNewFile,BufRead *.pbtxt setfiletype proto

  " https://vim-jp.org/vim-users-jp/2011/02/20/Hack-202.html
  augroup vimrc-auto-mkdir
    autocmd!
    autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
    function! s:auto_mkdir(dir, force) abort
      if !isdirectory(a:dir) && a:dir !~? '^[^:]*://'  && (a:force || input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
        call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
      endif
    endfunction
  augroup END

  if has('persistent_undo')
    let &undodir = has('nvim') ? stdpath('cache') . '/undo' : expand('~/.cache/undo')
    silent! call mkdir(&undodir, 'p')
    set undofile
  endif

  augroup vimrc-restore-view
    function! s:restore_view_check() abort
      return expand('%') !=# '' && &buftype !~# 'nofile' && &filetype !~# 'gitcommit'
    endfunction
    autocmd!
    autocmd BufWritePost,BufWinLeave * if s:restore_view_check() | silent! mkview | endif
    autocmd BufRead * if s:restore_view_check() | silent! loadview | endif
    set viewoptions=cursor,folds,slash,unix
  augroup END

  let g:netrw_banner = 0
  let g:netrw_preview = 0
  let g:netrw_liststyle = 1
  let g:netrw_sizestyle = 'H'
  let g:netrw_timefmt = '%Y/%m/%d %H:%M:%S'
endif

augroup vimrc-restore-ime
  autocmd!
  if exists('g:vscode') && filereadable('/proc/sys/fs/binfmt_misc/WSLInterop')
    let s:ime_status = '0'
    let s:ime_script = stdpath('config') . '/imeonoff.exe -s '
    autocmd InsertEnter * silent call system(s:ime_script . s:ime_status)
    autocmd InsertLeave * silent let s:ime_status = system(s:ime_script . '0')
  elseif exists('$TMUX')
    autocmd InsertEnter * silent call chansend(v:stderr, "\ePtmux;\e\e[<r\e\\")
    autocmd InsertLeave * silent call chansend(v:stderr, "\ePtmux;\e\e[<s\e\e[<0t\e\\")
    autocmd VimLeave * silent call chansend(v:stderr, "\ePtmux;\e\e[<0t\e\e[<s\e\\")
  else
    autocmd InsertEnter * silent call chansend(v:stderr, "\e[<r")
    autocmd InsertLeave * silent call chansend(v:stderr, "\e[<s\e[<0t")
    autocmd VimLeave * silent call chansend(v:stderr, "\e[<0t\e[<s")
  endif
augroup END

if has('win32') || has('win64') || has('mac')
  set clipboard=unnamed
else
  set clipboard=unnamedplus
endif
" }}}

set secure

