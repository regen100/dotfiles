local function to_table(p)
  if type(p) == 'string' then
    p = { p }
  end
  return p
end

local function b(p)
  p = to_table(p)
  p.event = { 'InsertEnter', 'CursorHold', 'FocusLost', 'BufRead', 'BufNewFile' }
  return p
end

local function o(p)
  p = to_table(p)
  p.opt = 1
  return p
end

local config = {
  o('tani/vim-jetpack'),
  --
  'nvim-lua/plenary.nvim',
  'kyazdani42/nvim-web-devicons',
  'bogado/file-line',
  {
    'folke/tokyonight.nvim',
    config = function()
      vim.cmd.colorscheme('tokyonight')
    end,
    setup = function()
      vim.g.tokyonight_style = 'night'
      vim.g.tokyonight_italic_keywords = false
    end,
  },
  {
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
  },
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.comment').setup({})
      require('mini.jump').setup({})
      require('mini.misc').setup({})
      require('mini.sessions').setup({})
      vim.fn.mkdir(require('mini.sessions').config.directory, 'p')
      require('mini.trailspace').setup({})
    end,
  },
  --
  b('jghauser/mkdir.nvim'),
  b('tpope/vim-repeat'),
  b('kana/vim-niceblock'),
  b('lambdalisue/readablefold.vim'),
  b('mbbill/undotree'),
  b('machakann/vim-sandwich'),
  b('tpope/vim-unimpaired'),
  b({
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  }),
  b({
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end,
  }),
  b({
    'folke/trouble.nvim',
    config = function()
      require('trouble').setup()
    end,
  }),
  b({
    'folke/todo-comments.nvim',
    config = function()
      require('todo-comments').setup()
    end,
  }),
  b({
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
  }),
  b({
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup()
    end,
  }),
  b({
    'EtiamNullam/deferred-clipboard.nvim',
    config = function()
      require('deferred-clipboard').setup({ lazy = true })
    end,
  }),
  b({
    'hoob3rt/lualine.nvim',
    config = function()
      require('lualine').setup({
        options = { theme = 'tokyonight', disabled_filetypes = { 'gundo', 'dap-repl', 'dapui_scopes', 'dapui_breakpoints', 'dapui_stacks', 'dapui_console', 'dapui_watches' } },
        tabline = { lualine_a = { 'buffers' }, lualine_z = { 'tabs' } },
      })
    end,
  }),
  o({
    'rcarriga/nvim-notify',
    requires = 'nvim-telescope/telescope.nvim',
  }),
  {
    'ahmedkhalf/project.nvim',
    event = { 'BufRead', 'BufNewFile' },
    config = function()
      require('project_nvim').setup()
    end,
  },
  {
    'lambdalisue/suda.vim',
    cmd = { 'SudaRead', 'SudaWrite' },
    setup = function()
      vim.cmd.cabbrev('w!!', 'SudaWrite')
    end,
  },
  -- treesitter
  b({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        highlight = { enable = true },
      })
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
      vim.opt.foldlevel = 10
    end,
  }),
  b({
    'p00f/nvim-ts-rainbow',
    requires = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter.configs').setup({
        rainbow = { enable = true, extended_mode = true, max_file_lines = nil },
      })
    end,
  }),
  b({
    'JoosepAlviste/nvim-ts-context-commentstring',
    requires = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter.configs').setup({
        context_commentstring = { enable = true },
      })
    end,
  }),
  b({
    'nvim-treesitter/nvim-treesitter-textobjects',
    requires = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter.configs').setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
        },
      })
    end,
  }),
  b({
    'nvim-treesitter/nvim-treesitter-context',
    requires = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('treesitter-context').setup()
    end,
  }),
  b({
    'haringsrob/nvim_context_vt',
    requires = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim_context_vt').setup({ prefix = ' »', disable_virtual_lines = true })
    end,
  }),
  -- telescope
  o('nvim-telescope/telescope-ui-select.nvim'),
  o('nvim-telescope/telescope-dap.nvim'),
  b({
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-telescope/telescope-ui-select.nvim', 'nvim-telescope/telescope-dap.nvim' },
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
      telescope.load_extension('dap')

      local builtin = require('telescope.builtin')
      require('which-key').register({
        ['<C-p>'] = { builtin.find_files, 'Find files' }, --
        ['<Leader>'] = {
          b = { builtin.buffers, 'Find buffers' }, --
        },
      })
    end,
  }),
  -- search & scrollbar
  b({
    'kevinhwang91/nvim-hlslens',
    requirs = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('hlslens').setup()
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
  }),
  b({
    'petertriho/nvim-scrollbar',
    requires = 'kevinhwang91/nvim-hlslens',
    config = function()
      require('scrollbar').setup()
      require('scrollbar.handlers.search').setup()
    end,
  }),
  -- lsp
  o('RRethy/vim-illuminate'),
  o('p00f/clangd_extensions.nvim'),
  o('simrat39/rust-tools.nvim'),
  o('jose-elias-alvarez/null-ls.nvim'),
  b({
    'neovim/nvim-lspconfig',
    requires = {
      'RRethy/vim-illuminate',
      'p00f/clangd_extensions.nvim',
      'simrat39/rust-tools.nvim',
      'jose-elias-alvarez/null-ls.nvim',
    },
    config = function()
      require('user.lsp').setup()
    end,
  }),
  -- lightbulb
  o('antoinemadec/FixCursorHold.nvim'),
  b({
    'kosayoda/nvim-lightbulb',
    requires = 'antoinemadec/FixCursorHold.nvim',
    config = function()
      require('nvim-lightbulb').setup({
        sign = { enabled = false },
        float = { enabled = true },
        autocmd = { enabled = true },
      })
    end,
  }),
  -- cmp
  o('hrsh7th/vim-vsnip-integ'),
  o('rafamadriz/friendly-snippets'),
  o({
    'hrsh7th/vim-vsnip',
    requires = { 'hrsh7th/vim-vsnip-integ', 'rafamadriz/friendly-snippets' },
    config = function()
      vim.cmd([[
          imap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
          smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
          imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
          smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
        ]])
    end,
  }),
  o('hrsh7th/cmp-nvim-lsp'),
  o({ 'hrsh7th/cmp-vsnip', requires = 'hrsh7th/vim-vsnip' }),
  o('hrsh7th/cmp-nvim-lsp-signature-help'),
  o('onsails/lspkind-nvim'),
  o('rcarriga/cmp-dap'),
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    config = function()
      vim.cmd.packadd('cmp-nvim-lsp')
      vim.cmd.packadd('cmp-vsnip')
      vim.cmd.packadd('cmp-nvim-lsp-signature-help')
      vim.cmd.packadd('lspkind-nvim')
      vim.cmd.packadd('cmp-dap')

      local cmp = require('cmp')
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
          { name = 'nvim_lsp_signature_help' },
        }),
        formatting = {
          format = require('lspkind').cmp_format({ mode = 'symbol_text', maxwidth = 100, menu = {
            nvim_lsp = '[LSP]',
            vsnip = '[vsnip]',
            nvim_lua = '[Lua]',
          } }),
        },
      })
      cmp.setup.filetype({ 'dap-repl', 'dapui_watches' }, {
        sources = {
          { name = 'dap' },
        },
      })
    end,
  },
  -- dap
  o('rcarriga/nvim-dap-ui'),
  o('theHamsta/nvim-dap-virtual-text'),
  b({
    'mfussenegger/nvim-dap',
    requires = { 'rcarriga/nvim-dap-ui', 'theHamsta/nvim-dap-virtual-text' },
    config = function()
      require('user.dap').setup()
    end,
  }),
}

local function setup()
  local root = vim.fn.stdpath('data') .. '/site/pack/jetpack'
  local src = root .. '/src/vim-jetpack'
  if vim.fn.filereadable(src) == 0 then
    vim.fn.system({
      'git',
      'clone',
      '--depth',
      '1',
      'https://github.com/tani/vim-jetpack.git',
      src,
    })
    local opt = root .. '/opt/vim-jetpack'
    vim.fn.mkdir(root .. '/opt', 'p')
    vim.loop.fs_symlink(src, opt)
  end
  vim.g.jetpack_copy_method = 'symlink'
  vim.cmd.packadd('vim-jetpack')
  require('jetpack.packer').add(config)

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.notify = function(message, level, opts)
    vim.cmd.packadd('nvim-notify')
    vim.notify = require('notify')
    vim.notify(message, level, opts)
  end
end

setup()
