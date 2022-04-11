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
vim.opt.listchars:append{eol = '↲', extends = '»', precedes = '«'}
vim.opt.matchpairs:append{'<:>'}
vim.opt.mouse = 'a'
vim.opt.scrolloff = 3
vim.opt.showbreak = '↳'
vim.opt.showmatch = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.splitbelow = true
vim.opt.virtualedit = 'block'
vim.opt.termguicolors = true
vim.opt.pumblend = 10
vim.opt.undofile = true
vim.opt.clipboard:append{'unnamedplus'}
vim.opt.viewoptions = {'cursor', 'folds', 'slash', 'unix'}

vim.cmd([[
  augroup vimrc
    autocmd!
  augroup END
]])

local jetpack_root = vim.fn.stdpath('data') .. '/site/pack/jetpack'
local install_path = jetpack_root .. '/src/vim-jetpack'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({
    'git', 'clone', '--depth', '1', 'https://github.com/tani/vim-jetpack.git',
    install_path
  })
  vim.fn.mkdir(jetpack_root .. '/opt', 'p')
  vim.loop.fs_symlink(install_path, jetpack_root .. '/opt/vim-jetpack')
end
vim.g['jetpack#copy_method'] = 'symlink'
vim.cmd('packadd vim-jetpack')
local hooks = {}
local jetpack = require('jetpack')
jetpack.startup(function(use)
  local function config(f) table.insert(hooks, f) end

  use {'tani/vim-jetpack', opt = 1}
  use 'tpope/vim-repeat'
  use 'kana/vim-niceblock'
  use 'jghauser/mkdir.nvim'
  use 'tpope/vim-unimpaired'
  use 'bogado/file-line'
  use 'kyazdani42/nvim-web-devicons'
  use 'nvim-lua/plenary.nvim'

  use 'LionC/nest.nvim'
  config(function()
    local builtin = require('telescope.builtin')
    require('nest').applyKeymaps {
      {'<Esc><Esc>', ':<C-u>nohlsearch<CR>'}, --
      {'<C-p>', builtin.find_files}, --
      {
        '<leader>', {
          {'o', '^f{a<CR><CR><UP>'}, --
          {'d', '"_d'}, --
          {
            'm',
            ':<C-u>let &mouse=(&mouse == "a" ? "" : "a")<CR>:set mouse?<CR>'
          }, --
          {'w', ':<C-u>setl wrap! wrap?<CR>'}, --
          {'fb', builtin.buffers}, --
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

  use {'lambdalisue/suda.vim', on = 'SudaWrite'}
  vim.cmd('cabbrev w!! SudaWrite')

  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use 'p00f/nvim-ts-rainbow'
  use 'JoosepAlviste/nvim-ts-context-commentstring'
  use 'romgrk/nvim-treesitter-context'
  config(function()
    require('nvim-treesitter.configs').setup {
      highlight = {enable = true},
      rainbow = {enable = true, extended_mode = true, max_file_lines = nil},
      context_commentstring = {enable = true}
    }

    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.opt.foldlevel = 2

    function _G.ensure_treesitter_language_installed()
      local lang = require('nvim-treesitter.parsers').get_buf_lang()
      pcall(require('nvim-treesitter.install').ensure_installed, lang)
    end
    vim.cmd(
        'autocmd vimrc BufEnter * ++once :lua ensure_treesitter_language_installed()')

    require('treesitter-context').setup()
  end)

  use 'hoob3rt/lualine.nvim'
  config(function()
    require('lualine').setup {
      options = {theme = 'tokyonight'},
      tabline = {lualine_a = {'buffers'}, lualine_z = {'tabs'}}
    }
  end)

  use 'lukas-reineke/indent-blankline.nvim'
  config(function()
    require('indent_blankline').setup {
      filetype_exclude = {'', 'help', 'gitcommit', 'lspinfo'},
      buftype_exclude = {'terminal'},
      space_char_blankline = ' ',
      show_current_context = true,
      show_end_of_line = true
    }
  end)

  use 'nvim-telescope/telescope.nvim'
  config(function()
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
  config(function()
    vim.g.tokyonight_style = 'night'
    vim.g.tokyonight_italic_keywords = false
    vim.cmd('colorscheme tokyonight')
  end)

  use 'norcalli/nvim-colorizer.lua'
  config(function() require('colorizer').setup() end)

  use 'lewis6991/gitsigns.nvim'
  config(function() require('gitsigns').setup() end)

  use 'folke/trouble.nvim'
  config(function() require('trouble').setup() end)

  use 'echasnovski/mini.nvim'
  config(function()
    require('mini.comment').setup()
    require('mini.jump').setup()
    require('mini.misc').setup()
    require('mini.sessions').setup()
    require('mini.starter').setup()
    require('mini.surround').setup()
    require('mini.trailspace').setup()
    vim.cmd('highlight link MiniTrailspace NvimInternalError')
  end)

  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'p00f/clangd_extensions.nvim'
  use 'kosayoda/nvim-lightbulb'
  use 'onsails/lspkind-nvim'
  use 'ray-x/lsp_signature.nvim'
  config(function() require('user.lsp').setup() end)
end)
for _, name in ipairs(vim.fn['jetpack#names']()) do
  if jetpack.tap(name) == 0 then
    jetpack.sync()
    break
  end
end
for _, f in ipairs(hooks) do f() end

vim.cmd([[
  autocmd vimrc InsertLeave * set nopaste

  autocmd vimrc FileType * setlocal formatoptions-=ro
  autocmd vimrc FileType c,cpp,java setlocal commentstring=//\ %s
  autocmd vimrc FileType help nnoremap <buffer> q <C-w>c
  autocmd vimrc FileType help nnoremap <buffer> <Esc> <C-w>c

  autocmd vimrc BufNewFile,BufRead *.tmux setfiletype tmux
  autocmd vimrc BufNewFile,BufRead *.gitconfig.* setfiletype gitconfig
  autocmd vimrc BufNewFile,BufRead *.nspawn setfiletype systemd
  autocmd vimrc BufNewFile,BufRead .clang-tidy,.clang-format setfiletype yaml
  autocmd vimrc BufNewFile,BufRead *.pbtxt,*.pb.txt setfiletype proto
  autocmd vimrc BufNewFile,BufRead .textlintrc setfiletype json

  augroup vimrc-restore-view
    function! s:restore_view_check() abort
      return expand('%') !=# '' && &buftype !~# 'nofile' && &filetype !~# 'gitcommit'
    endfunction
    autocmd!
    autocmd BufWinLeave * if s:restore_view_check() | mkview | endif
    autocmd BufEnter * silent! loadview
  augroup END

  augroup vimrc-restore-ime
    autocmd!
    if exists('g:vscode') && !empty($WSL_DISTRO_NAME)
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
