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

"plugin {{{
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
Plug 'w0ng/vim-hybrid'
Plug 'sheerun/vim-polyglot'
  let g:cpp_class_scope_highlight = 1
  let g:cpp_member_variable_highlight = 1
  let g:cpp_class_decl_highlight = 1
  let g:cpp_experimental_simple_template_highlight = 1
  let g:cpp_concepts_highlight = 1
  let g:cpp_no_function_highlight = 1
  let g:vim_json_syntax_conceal = 0
  let g:markdown_enable_conceal = 0
  autocmd vimrc BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css
Plug 'anntzer/vim-cython'
Plug 'vhda/verilog_systemverilog.vim'
Plug 'lervag/vimtex'
  let g:vimtex_compiler_latexmk = {
  \ 'continuous': 1,
  \ 'options': [
  \   '-pdfdvi',
  \   '-verbose',
  \   '-file-line-error',
  \   '-synctex=1',
  \   '-interaction=nonstopmode',
  \ ],
  \}
  if executable('qpdfview')
    let g:vimtex_view_general_viewer = 'qpdfview'
    let g:vimtex_view_general_options = '--unique @pdf\#src:@tex:@line:@col'
    let g:vimtex_view_general_options_latexmk = '--unique'
  endif
Plug 'scrooloose/nerdtree'
  let g:NERDTreeRespectWildIgnore = 1
  nnoremap <silent> <Leader>n :<C-u>NERDTreeToggle<CR>
  autocmd vimrc BufEnter * if (winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree()) | q | endif
  Plug 'ryanoasis/vim-devicons'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Yggdroot/indentLine'
  let g:indentLine_fileTypeExclude = ['help', 'tagbar', 'git', '']
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
  function! CocCurrentFunction() abort
    return get(b:, 'coc_current_function', '')
  endfunction
  let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ 'component_expand': {
  \   'linter_checking': 'lightline#ale#checking',
  \   'linter_warnings': 'lightline#ale#warnings',
  \   'linter_errors': 'lightline#ale#errors',
  \   'linter_ok': 'lightline#ale#ok',
  \   'buffers': 'lightline#bufferline#buffers',
  \ },
  \ 'component_type': {
  \   'linter_checking': 'left',
  \   'linter_warnings': 'warning',
  \   'linter_errors': 'error',
  \   'linter_ok': 'left',
  \   'buffers': 'tabsel',
  \ },
  \ 'component': {
  \   'filename_readonly_modified': '%t' . '%{&readonly ? "\ue0a2" : ""}' . '%m',
  \   'lineinfo_percent': '%3p%% %3l:%-2v',
  \   'lightline_hunks': '%{winwidth(0) > 100 ? lightline#hunks#composer() : ""}',
  \ },
  \ 'component_function': {
  \   'cocstatus': 'coc#status',
  \   'currentfunction': 'CocCurrentFunction'
  \ },
  \ 'active': {
  \   'left': [['mode', 'paste'], ['lightline_hunks'], ['filename_readonly_modified'], ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok'], ['cocstatus', 'currentfunction']],
  \   'right': [['lineinfo_percent'], ['fileformat', 'fileencoding', 'filetype']]
  \ },
  \ 'tabline': {'left': [['buffers']], 'right': [['close']]},
  \}
  set showtabline=2
  Plug 'maximbaz/lightline-ale'
    let g:lightline#ale#indicator_checking = "\uf110"
    let g:lightline#ale#indicator_warnings = "\uf071"
    let g:lightline#ale#indicator_errors = "\uf05e"
    let g:lightline#ale#indicator_ok = "\uf00c"
  Plug 'mengelbrecht/lightline-bufferline'
    let g:lightline#bufferline#show_number = 1
  Plug 'sinetoami/lightline-hunks'
    let g:lightline#hunks#exclude_filetypes = ['help', 'nerdtree', 'tagbar']
Plug 'lilydjwg/colorizer'
Plug 'junegunn/rainbow_parentheses.vim'
  let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
  autocmd vimrc FileType cpp RainbowParentheses
Plug 'thinca/vim-zenspace'
Plug 'bronson/vim-trailing-whitespace'
  autocmd vimrc BufWritePre * FixWhitespace
Plug 'w0rp/ale'
  let g:ale_sign_column_always = 1
  let g:ale_cpp_clangcheck_options='-extra-arg=-D__clang_analyzer__ -extra-arg=-fno-color-diagnostics'
  let g:ale_cpp_cppcheck_options='--enable=all --suppress=unusedFunction --suppress=syntaxError'
  let g:ale_cpp_clangtidy_checks=[]
  let g:ale_c_clangformat_options = '-fallback-style=Google -style=file'
  let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
  let g:ale_fix_on_save = 1
  let g:ale_linters = { 'cpp': ['clangcheck', 'clangtidy_h', 'cppcheck', 'cpplint', 'clang-format'] }
  let g:ale_fixers = {
  \ 'cpp': ['clang-format'],
  \ 'python': ['isort'],
  \ 'qml': ['qmlfmt'],
  \ 'verilog': [
  \   {buffer, lines -> {'command': 'iStyle --style=ansi -s2 -p -n %t', 'read_temporary_file': 1}}
  \ ]
  \}
  let g:ale_fixers.verilog_systemverilog = g:ale_fixers.verilog
  let g:ale_linter_aliases = {
  \ 'verilog_systemverilog': ['verilog']
  \}
  autocmd vimrc FileType cpp if exists('g:build_dir') | let g:ale_c_build_dir = g:build_dir | endif
  nmap [w <Plug>(ale_previous_wrap)
  nmap ]w <Plug>(ale_next_wrap)
Plug 'tyru/caw.vim'
Plug 'tpope/vim-surround'
Plug 'itchyny/vim-cursorword'
Plug 'easymotion/vim-easymotion'
  let g:EasyMotion_use_migemo = 1
Plug 'kana/vim-altr'
  nmap <Leader>a <Plug>(altr-forward)
  nmap <Leader>A <Plug>(altr-back)
  autocmd vimrc VimEnter * call altr#define('%/include/%.hpp', '%/include/*/%.hpp', '%/include/*/*/%.hpp', '%/include/*/*/%.inl.hpp', '%/src/%.hpp', '%/src/%.h', '%/src/%.cpp', '%/test/%Test.cpp', '%/test/%_test.cpp', '%/test/%.cpp')
Plug 'christoomey/vim-tmux-navigator'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-repeat'
Plug 'vim-scripts/DoxygenToolkit.vim', {'for': ['c', 'cpp', 'python']}
Plug 'sjl/gundo.vim',  {'on': ['GundoToggle']}
  let g:gundo_close_on_revert = 1
  let g:gundo_auto_preview = 0
  let g:gundo_prefer_python3 = 1
  nnoremap <Leader>u :<C-u>GundoToggle<CR>
Plug 'Valloric/ListToggle'
Plug 'kana/vim-niceblock'
  xmap I <Plug>(niceblock-I)
  xmap A <Plug>(niceblock-A)
Plug 'thaerkh/vim-workspace'
  let g:workspace_session_disable_on_args = 1
  let g:workspace_persist_undo_history = 0
  let g:workspace_autosave = 0
if has('nvim')
  Plug 'jeffkreeftmeijer/vim-numbertoggle'
endif
if executable('node')
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
    inoremap <silent><expr> <c-space> coc#refresh()
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)
    autocmd vimrc FileType c,cpp,objc,objcpp,cs,go,javascript,python,rust nmap <buffer> <silent> <CR> <Plug>(coc-definition)
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)
    nnoremap <silent> K :call <SID>show_documentation()<CR>
    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      else
        call CocAction('doHover')
      endif
    endfunction
    command! -nargs=0 Format :call CocAction('format')
    nmap <leader>cr <Plug>(coc-rename)
    xmap <silent> <leader>cf <Plug>(coc-format-selected)
    nnoremap <silent> <leader>cf :<C-u>Format<cr>
    nnoremap <silent> <leader>ca :<C-u>CocList diagnostics<cr>
    nnoremap <silent> <leader>ce :<C-u>CocList extensions<cr>
    nnoremap <silent> <leader>cc :<C-u>CocList commands<cr>
    nnoremap <silent> <leader>co :<C-u>CocList outline<cr>
    nnoremap <silent> <leader>cs :<C-u>CocList -I symbols<cr>
    inoremap <silent><expr> <TAB>
        \ pumvisible() ? coc#_select_confirm() :
        \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction
    let g:coc_snippet_next = '<tab>'
    let g:coc_global_extensions = ['coc-json', 'coc-python', 'coc-yaml', 'coc-snippets', 'coc-highlight']
    if executable('rustc')
      call add(g:coc_global_extensions, 'coc-rls')
    endif
endif
if $USER !=# 'root' && !empty(glob('/tmp/fcitx-socket-*')) && $DISPLAY ==# ':0'
  Plug 'lilydjwg/fcitx.vim'
endif
if executable('fzf')
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
    noremap <Leader>e :<C-u>Files<CR>
    noremap <Leader>b :<C-u>Buffers<CR>
    if has('nvim')
      tnoremap <expr> <Esc> (&filetype == 'fzf') ? '<Esc>' : '<c-\><c-n>'
    endif
  Plug 'n04ln/yankee.vim'
endif
call plug#end()

if s:vimplug_install || exists('g:force_install')
  PlugInstall --sync
endif
" }}}

" set  {{{
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
set ignorecase smartcase incsearch
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

if has('win32') || has('win64') || has('mac')
  set clipboard=unnamed
else
  set clipboard=unnamed,unnamedplus
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
" }}}

set secure
