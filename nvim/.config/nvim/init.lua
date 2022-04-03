vim.g.mapleader = ' '
vim.g.netrw_banner = 0
vim.g.netrw_preview = 0
vim.g.netrw_liststyle = 1
vim.g.netrw_sizestyle = 'H'
vim.g.netrw_timefmt = '%Y-%m-%d %H:%M:%S'

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.wrap = false
vim.opt.list = true
vim.opt.listchars:append({eol = '↲', extends = '»', precedes = '«'})
vim.opt.matchpairs:append({'<:>'})
vim.opt.mouse = 'a'
vim.opt.scrolloff = 3
vim.opt.showbreak = '↳'
vim.opt.showmatch = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.splitbelow = true
vim.opt.virtualedit:append({'block'})
vim.opt.termguicolors = true
vim.opt.pumblend = 30
vim.opt.undofile = true
vim.opt.clipboard:append({'unnamedplus'})

vim.cmd([[
  augroup vimrc
    autocmd!
  augroup END
]])

local install_path = vim.fn.stdpath('data') ..
                         '/site/pack/jetpack/start/jetpack'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  JETPACK_BOOTSTRAP = vim.fn.system({
    'git', 'clone', '--depth', '1', 'https://github.com/tani/vim-jetpack.git',
    install_path
  })
end

local config = {}
local jetpack = require('jetpack')
jetpack.startup(function(use)
  use 'tpope/vim-repeat'
  use 'kana/vim-niceblock'
  use 'tpope/vim-commentary'
  use 'jghauser/mkdir.nvim'
  use 'lilydjwg/colorizer'
  use 'thinca/vim-zenspace'
  use 'tpope/vim-unimpaired'
  use 'mhinz/vim-startify'
  use 'bogado/file-line'
  use 'kyazdani42/nvim-web-devicons'
  use 'nvim-lua/plenary.nvim'

  use 'LionC/nest.nvim'
  table.insert(config, function()
    require('nest').applyKeymaps {
      {'<Esc><Esc>', ':<C-u>nohlsearch<CR>'}, --
      {'<C-p>', require('telescope.builtin').find_files}, --
      {
        '<leader>', {
          {'o', '^f{a<CR><CR><UP>'}, --
          {'d', '"_d'}, --
          {'l', ':call ToggleLocationList()<CR>'}, --
          {
            'm',
            ":<C-u>let &mouse=(&mouse == 'a' ? '' : 'a')<CR>:set mouse?<CR>"
          }, --
          {'w', ':<C-u>setl wrap! wrap?<CR>'}, --
          {'fb', require('telescope.builtin').buffers}, --
          {
            'rr',
            ':%s/\\<<C-r><C-w>\\>//g<Left><Left>',
            options = {silent = false}
          } --
        }
      }, {
        mode = 'v',
        {
          {'<TAB>', '>gv'}, --
          {'<S-TAB>', '<gv'}, --
          {'<LeftRelease>', 'y<CR>gv<LeftRelease>'} --
        }
      }
    }
  end)

  use 'easymotion/vim-easymotion'
  vim.g.EasyMotion_use_migemo = 1

  use {'lambdalisue/suda.vim', on = 'SudaWrite'}
  vim.cmd('cabbrev w!! SudaWrite')

  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use 'p00f/nvim-ts-rainbow'
  table.insert(config, function()
    require('nvim-treesitter.configs').setup {
      highlight = {enable = true},
      rainbow = {enable = true, extended_mode = true, max_file_lines = nil}
    }

    function _G.ensure_treesitter_language_installed()
      local lang = require('nvim-treesitter.parsers').get_buf_lang()
      pcall(require('nvim-treesitter.install').ensure_installed, lang)
    end
    vim.cmd(
        'autocmd vimrc BufEnter * :lua ensure_treesitter_language_installed()')
  end)

  use 'hoob3rt/lualine.nvim'
  table.insert(config, function()
    require('lualine').setup {
      options = {theme = 'tokyonight'},
      tabline = {lualine_a = {'buffers'}, lualine_z = {'tabs'}}
    }
  end)

  use 'lukas-reineke/indent-blankline.nvim'
  table.insert(config, function()
    require('indent_blankline').setup {
      char = '|',
      filetype_exclude = {'help', 'gitcommit'},
      buftype_exclude = {'terminal'}
    }
  end)

  use 'nvim-telescope/telescope.nvim'
  table.insert(config, function()
    require('telescope').setup {
      defaults = {
        mappings = {
          i = {
            ['<Esc>'] = require('telescope.actions').close --
          }
        }
      }
    }
  end)

  use 'folke/tokyonight.nvim'
  table.insert(config, function()
    vim.g.tokyonight_style = 'night'
    vim.g.tokyonight_italic_keywords = false
    vim.cmd('colorscheme tokyonight')
  end)

  use 'milkypostman/vim-togglelist'
  vim.g.toggle_list_no_mappings = 1

  use 'sheerun/vim-polyglot'
  vim.g.cpp_class_scope_highlight = 1
  vim.g.cpp_member_variable_highlight = 1
  vim.g.cpp_class_decl_highlight = 1
  vim.g.cpp_experimental_simple_template_highlight = 1
  vim.g.cpp_concepts_highlight = 1
  vim.g.cpp_no_function_highlight = 1
  vim.g.vim_json_syntax_conceal = 0
  vim.g.vim_markdown_conceal = 0
  vim.g.vim_markdown_conceal_code_blocks = 0

  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lsp'
  table.insert(config, function() require('user.lsp') end)

  if JETPACK_BOOTSTRAP then jetpack.sync() end
end)
for _, v in ipairs(config) do v() end

vim.cmd([[
  autocmd vimrc InsertLeave * set nopaste

  autocmd vimrc FileType * setlocal formatoptions-=ro
  autocmd vimrc FileType c,cpp,java setlocal commentstring=//\ %s

  autocmd vimrc BufNewFile,BufRead *.tmux setfiletype tmux
  autocmd vimrc BufNewFile,BufRead *.gitconfig.* setfiletype gitconfig
  autocmd vimrc BufNewFile,BufRead *.nspawn setfiletype systemd
  autocmd vimrc BufNewFile,BufRead .clang-tidy,.clang-format setfiletype yaml
  autocmd vimrc BufNewFile,BufRead *.pbtxt,*.pb.txt setfiletype proto
  autocmd vimrc BufNewFile,BufRead .textlintrc setfiletype json

  autocmd vimrc FileType help nnoremap <buffer> q <C-w>c

  augroup vimrc-restore-view
    function! s:restore_view_check() abort
      return expand('%') !=# '' && &buftype !~# 'nofile' && &filetype !~# 'gitcommit'
    endfunction
    autocmd!
    autocmd BufWritePost,BufWinLeave * if s:restore_view_check() | silent! mkview | endif
    autocmd BufRead * if s:restore_view_check() | silent! loadview | endif
    set viewoptions=cursor,folds,slash,unix
  augroup END

  augroup vimrc-restore-ime
    autocmd!
    if exists('g:vscode') && filereadable('/proc/sys/fs/binfmt_misc/WSLInterop')
      let b:ime_status = '0'
      let s:ime_script = stdpath('config') . '/imeonoff.exe -s '
      autocmd InsertEnter * silent call system(s:ime_script . b:ime_status)
      autocmd InsertLeave * silent let b:ime_status = system(s:ime_script . '0')
    elseif exists('$TMUX')
      call chansend(v:stderr, "\ePtmux;\e\e[<0t\e\e[<s\e\\")
      autocmd InsertEnter * silent call chansend(v:stderr, "\ePtmux;\e\e[<r\e\\")
      autocmd InsertLeave * silent call chansend(v:stderr, "\ePtmux;\e\e[<s\e\e[<0t\e\\")
      autocmd VimLeave * silent call chansend(v:stderr, "\ePtmux;\e\e[<0t\e\e[<s\e\\")
    else
      call chansend(v:stderr, "\e[<0t\e[<s")
      autocmd InsertEnter * silent call chansend(v:stderr, "\e[<r")
      autocmd InsertLeave * silent call chansend(v:stderr, "\e[<s\e[<0t")
      autocmd VimLeave * silent call chansend(v:stderr, "\e[<0t\e[<s")
    endif
  augroup END
]])

vim.opt.secure = true
