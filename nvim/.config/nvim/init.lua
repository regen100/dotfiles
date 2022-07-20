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
vim.opt.listchars:append({ eol = '↲', extends = '»', precedes = '«' })
vim.opt.matchpairs:append({ '<:>' })
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
vim.opt.clipboard:append({ 'unnamedplus' })
vim.opt.viewoptions = { 'cursor', 'folds', 'slash', 'unix' }
vim.opt.guicursor:append({ 'c:ver25' })

vim.cmd([[
  augroup vimrc
    autocmd!
  augroup END
  colorscheme desert
]])

require('user.jetpack').startup(function(use)
  use({ 'tani/vim-jetpack', opt = 1 })

  use({
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require('notify')
    end,
  })

  use('tpope/vim-repeat')
  use('kana/vim-niceblock')
  use('jghauser/mkdir.nvim')
  use('tpope/vim-unimpaired')
  use('bogado/file-line')
  use('kyazdani42/nvim-web-devicons')
  use('nvim-lua/plenary.nvim')
  use('lambdalisue/readablefold.vim')
  use('sakhnik/nvim-gdb')
  use('machakann/vim-sandwich')

  vim.g.gundo_prefer_python3 = 1
  use('sjl/gundo.vim')

  use({
    'folke/which-key.nvim',
    config = function()
      local wk = require('which-key')
      wk.setup()
      wk.register({
        ['<Esc><Esc>'] = { ':<C-u>nohlsearch<CR>', '' }, --
        ['<Tab>'] = { 'V>', 'Indent' }, --
        ['<S-Tab>'] = { 'V<', 'Unindent' }, --
        ['<Leader>'] = {
          o = { '^f{a<CR><CR><Up>', 'Open {}' }, --
          m = { '<Cmd>let &mouse=(&mouse == "a" ? "" : "a")<CR><Cmd>set mouse?<CR>', 'Toggle mouse' }, --
          w = { '<Cmd>setl wrap! wrap?<CR>', 'Toggle wrap' }, --
          rr = { ':%s/\\<<C-r><C-w>\\>//g<Left><Left>', 'Rename', silent = false }, --
        }, --
      })
      wk.register({
        ['<Tab>'] = { '>gv', 'Indent' }, --
        ['<S-Tab>'] = { '<gv', 'Unindent' }, --
        ['<LeftRelease>'] = { 'y<CR>gv<LeftRelease>', '' }, --
      }, { mode = 'v' })
    end,
  })

  use({ 'lambdalisue/suda.vim', on = 'SudaWrite', config = 'cabbrev w!! SudaWrite' })

  use('p00f/nvim-ts-rainbow')
  use('JoosepAlviste/nvim-ts-context-commentstring')
  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        highlight = { enable = true },
        rainbow = { enable = true, extended_mode = true, max_file_lines = nil },
        context_commentstring = { enable = true },
      })

      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
      vim.opt.foldlevel = 10

      function _G.ensure_treesitter_language_installed()
        local lang = require('nvim-treesitter.parsers').get_buf_lang()
        pcall(require('nvim-treesitter.install').ensure_installed, lang)
      end
      vim.cmd('autocmd vimrc BufEnter * ++once :lua ensure_treesitter_language_installed()')
    end,
  })
  use({
    'lewis6991/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup()
      vim.cmd('autocmd vimrc VimEnter * highlight TreesitterContext gui=underline')
    end,
  })
  use({
    'haringsrob/nvim_context_vt',
    config = function()
      require('nvim_context_vt').setup({ prefix = ' »', disable_virtual_lines = true })
    end,
  })

  use({
    'hoob3rt/lualine.nvim',
    config = function()
      require('lualine').setup({
        options = { theme = 'tokyonight' },
        tabline = { lualine_a = { 'buffers' }, lualine_z = { 'tabs' } },
      })
    end,
  })

  use({
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup({
        filetype_exclude = { '', 'help', 'gitcommit', 'lspinfo', 'starter' },
        buftype_exclude = { 'terminal' },
        space_char_blankline = ' ',
        show_current_context = true,
        show_end_of_line = true,
      })
    end,
  })

  use({ 'nvim-telescope/telescope-ui-select.nvim' })
  use({
    'nvim-telescope/telescope.nvim',
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ['<Esc>'] = actions.close, --
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown({}),
          },
        },
      })
      telescope.load_extension('ui-select')

      local builtin = require('telescope.builtin')
      require('which-key').register({
        ['<C-p>'] = { builtin.find_files, 'Find files' }, --
        ['<Leader>'] = {
          fb = { builtin.buffers, 'Find buffers' }, --
        },
      })
    end,
  })

  use({ 'folke/tokyonight.nvim', config = 'colorscheme tokyonight' })
  vim.g.tokyonight_style = 'night'
  vim.g.tokyonight_italic_keywords = false

  use({
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  })

  use({
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end,
  })

  use({
    'folke/trouble.nvim',
    config = function()
      require('trouble').setup()
    end,
  })

  use({
    'echasnovski/mini.nvim',
    config = function()
      require('mini.comment').setup({})
      require('mini.jump').setup({})
      require('mini.misc').setup({})
      require('mini.sessions').setup({})
      vim.fn.mkdir(require('mini.sessions').config.directory, 'p')
      require('mini.starter').setup({})
      require('mini.trailspace').setup({})
      vim.cmd('highlight link MiniTrailspace NvimInternalError')
    end,
  })

  use({
    'folke/todo-comments.nvim',
    config = function()
      require('todo-comments').setup()
    end,
  })

  use({
    'kevinhwang91/nvim-hlslens',
    config = function()
      local start = [[<Cmd>lua require('hlslens').start()<CR>]]
      require('which-key').register({
        n = { [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR>]] .. start, '' },
        N = { [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR>]] .. start, '' },
        ['*'] = { '*' .. start, '' },
        ['#'] = { '#' .. start, '' },
        ['g*'] = { 'g*' .. start, '' },
        ['g#'] = { 'g#' .. start, '' },
      })
    end,
  })

  use({
    'petertriho/nvim-scrollbar',
    config = function()
      require('scrollbar').setup()
      require('scrollbar.handlers.search').setup()
    end,
  })

  use({
    'nathom/filetype.nvim',
    config = function()
      require('filetype').setup({
        overrides = {
          extensions = {
            tmux = 'tmux',
            pbtxt = 'proto',
          },
          literal = {
            ['.clang-tidy'] = 'yaml',
            ['.textlintrc'] = 'json',
          },
          complex = {
            ['.gitconfig*'] = 'gitconfig', -- Included in the plugin
          },
        },
      })
      vim.cmd([[
        autocmd vimrc BufNewFile,BufRead * source $VIMRUNTIME/scripts.vim
        autocmd vimrc FileType * setlocal formatoptions-=ro
        autocmd vimrc FileType c,cpp,java setlocal commentstring=//\ %s
        autocmd vimrc FileType help nnoremap <buffer> q <C-w>c
        autocmd vimrc FileType help nnoremap <buffer> <Esc> <C-w>c
      ]])
    end,
  })

  use('p00f/clangd_extensions.nvim')
  use('RRethy/vim-illuminate')
  use({
    'neovim/nvim-lspconfig',
    config = function()
      require('user.lsp').setup()
    end,
  })
  use({
    'kosayoda/nvim-lightbulb',
    config = function()
      require('nvim-lightbulb').setup({
        sign = { enabled = false },
        float = { enabled = true },
      })
      vim.cmd([[autocmd vimrc CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()]])
    end,
  })
  use({
    'ray-x/lsp_signature.nvim',
    config = function()
      require('lsp_signature').setup()
    end,
  })
  use({
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup()
    end,
  })

  use({ 'hrsh7th/vim-vsnip', config = [[
    imap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
    smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
    imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
    smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
  ]] })
  use('hrsh7th/vim-vsnip-integ')
  use('rafamadriz/friendly-snippets')

  use('hrsh7th/cmp-nvim-lsp')
  use('hrsh7th/cmp-vsnip')
  use('onsails/lspkind-nvim')
  use({
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require('cmp')
      assert(cmp ~= nil)
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete({}),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
        }),
        formatting = {
          format = require('lspkind').cmp_format({ mode = 'symbol_text', maxwidth = 100, menu = {
            nvim_lsp = '[LSP]',
            vsnip = '[vsnip]',
            nvim_lua = '[Lua]',
          } }),
        },
      })
    end,
  })
end)

require('user.autosave').setup()

vim.cmd([[
  autocmd vimrc InsertLeave * set nopaste

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
