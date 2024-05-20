local config = {
  'bogado/file-line',
  'tpope/vim-repeat',
  'kana/vim-niceblock',
  'machakann/vim-sandwich',
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    opts = function()
      require('catppuccin').setup({
        integrations = {
          cmp = true,
          fern = true,
          fidget = true,
          gitsigns = true,
          mini = true,
          notify = true,
          treesitter = true,
          ts_rainbow = true,
          which_key = true,
          indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
          },
        },
      })
      vim.cmd.colorscheme('catppuccin')
    end,
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      local wk = require('which-key')
      wk.setup()
      wk.register({
        ['<Esc><Esc>'] = { ':<C-u>nohlsearch<CR>', '' }, --
        ['<Tab>'] = { 'V>', 'Indent' }, --
        ['<S-Tab>'] = { 'V<', 'Unindent' }, --
        ['<Leader>'] = {
          m = {
            function()
              if next(vim.opt.mouse:get()) then
                vim.opt.mouse = {}
              else
                vim.opt.mouse = { a = true }
              end
            end,
            'Toggle mouse',
          }, --
          w = {
            function()
              ---@diagnostic disable-next-line: undefined-field
              vim.opt.wrap = not vim.opt.wrap:get()
            end,
            'Toggle wrap',
          }, --
          rr = { [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], 'Rename', silent = false }, --
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
      require('mini.sessions').setup({})
      vim.fn.mkdir(require('mini.sessions').config.directory, 'p')
      require('mini.trailspace').setup({})
    end,
  },
  --
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'nvim-tree/nvim-web-devicons', lazy = true },
  { 'jghauser/mkdir.nvim', event = 'BufWritePre' },
  { 'lambdalisue/readablefold.vim', event = { 'BufRead', 'BufNewFile' } },
  { 'rhysd/conflict-marker.vim', event = { 'BufRead', 'BufNewFile' } },
  {
    'mbbill/undotree',
    cmd = { 'UndotreeToggle', 'UndotreeShow' },
    init = function()
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_DiffCommand = 'diff -u'
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
  {
    'norcalli/nvim-colorizer.lua',
    event = { 'BufRead', 'BufNewFile' },
    opts = {},
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'folke/trouble.nvim',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = 'VeryLazy',
    opts = {},
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
    main = 'ibl',
    opts = {},
  },
  {
    'hoob3rt/lualine.nvim',
    event = 'VeryLazy',
    opts = {
      options = { theme = 'catppuccin', disabled_filetypes = { 'gundo', 'dap-repl', 'dapui_scopes', 'dapui_breakpoints', 'dapui_stacks', 'dapui_console', 'dapui_watches' } },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = {
          {
            function()
              return require('lazy.status').updates()
            end,
            cond = function()
              return require('lazy.status').has_updates
            end,
            color = { fg = '#ff9e64' },
          },
          'encoding',
          'fileformat',
          'filetype',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    },
  },
  {
    'romgrk/barbar.nvim',
    lazy = false,
    keys = {
      { '[b', '<Cmd>BufferPrevious<CR>', desc = 'Go to previous buffer' },
      { ']b', '<Cmd>BufferNext<CR>', desc = 'Go to next buffer' },
      { '<A-1>', '<Cmd>BufferGo 1<CR>' },
      { '<A-2>', '<Cmd>BufferGo 2<CR>' },
      { '<A-3>', '<Cmd>BufferGo 3<CR>' },
      { '<A-4>', '<Cmd>BufferGo 4<CR>' },
      { '<A-5>', '<Cmd>BufferGo 5<CR>' },
      { '<A-6>', '<Cmd>BufferGo 6<CR>' },
      { '<A-7>', '<Cmd>BufferGo 7<CR>' },
      { '<A-8>', '<Cmd>BufferGo 8<CR>' },
      { '<A-9>', '<Cmd>BufferGo 9<CR>' },
      { '<A-0>', '<Cmd>BufferLast<CR>' },
      { '<A-p>', '<Cmd>BufferPin<CR>' },
      { '<A-c>', '<Cmd>BufferClose<CR>' },
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      icons = {
        buffer_index = true,
      },
    },
  },
  {
    'rcarriga/nvim-notify',
    lazy = true,
    init = function()
      vim.notify = require('notify')
    end,
  },
  {
    'lambdalisue/suda.vim',
    cmd = { 'SudaRead', 'SudaWrite' },
    init = function()
      vim.cmd.cabbrev('w!!', 'SudaWrite')
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'VeryLazy', 'FileType' },
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      'nvim-treesitter/nvim-treesitter-textobjects',
      {
        'nvim-treesitter/nvim-treesitter-context',
        config = function()
          require('treesitter-context').setup()
        end,
      },
      {
        'haringsrob/nvim_context_vt',
        config = function()
          require('nvim_context_vt').setup({ prefix = ' »', disable_virtual_lines = true })
        end,
      },
    },
    build = ':TSUpdate',
    init = function()
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
      vim.opt.foldenable = false
    end,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup({
        ensure_installed = { 'markdown_inline' },
        auto_install = true,
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        rainbow = { enable = true, extended_mode = true, max_file_lines = nil },
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
  },
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    keys = {
      {
        '<C-p>',
        function()
          require('telescope.builtin').find_files()
        end,
        desc = 'Find files',
      },
      {
        '<Leader>b',
        function()
          require('telescope.builtin').buffers()
        end,
        desc = 'Find buffers',
      },
    },
    dependencies = {
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-telescope/telescope-dap.nvim',
    },
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
        pickers = {
          find_files = {
            find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/' },
          },
        },
      })
      telescope.load_extension('notify')
      telescope.load_extension('ui-select')
      telescope.load_extension('dap')
    end,
  },
  {
    'kevinhwang91/nvim-hlslens',
    lazy = true,
    init = function()
      local mapping = {
        n = [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR>]],
        N = [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR>]],
        '*',
        '#',
        'g*',
        'g#',
      }
      for k, v in pairs(mapping) do
        if type(k) == 'number' then
          k = v
        end
        vim.keymap.set('n', k, v .. [[<Cmd>lua require('hlslens').start()<CR>]])
      end
    end,
    opts = {},
  },
  {
    'petertriho/nvim-scrollbar',
    event = 'VeryLazy',
    config = function()
      require('scrollbar').setup({
        excluded_filetypes = {
          'prompt',
          'TelescopePrompt',
          'noice',
          'sagafinder',
        },
      })
      require('scrollbar.handlers.search').setup()
      require('scrollbar.handlers.gitsigns').setup()
    end,
  },
  {
    'RRethy/vim-illuminate',
    event = 'VeryLazy',
    config = function()
      require('illuminate').configure({ filetypes_denylist = { 'sagafinder' } })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'nvimtools/none-ls.nvim',
        dependencies = {
          'nvimtools/none-ls-extras.nvim',
        },
        config = function()
          local null_ls = require('null-ls')
          local jsonnetfmt = {
            method = null_ls.methods.FORMATTING,
            filetypes = { 'jsonnet' },
            generator = require('null-ls.helpers').formatter_factory({
              command = 'jsonnetfmt',
              args = { '-' },
              to_stdin = true,
            }),
          }
          local null_ls_sources = {
            -- shell
            null_ls.builtins.diagnostics.zsh,
            null_ls.builtins.formatting.shfmt.with({
              extra_args = { '-i', '2', '-ci' },
            }),
            -- python
            null_ls.builtins.diagnostics.mypy.with({
              extra_args = { '--strict' },
            }),
            -- lua
            null_ls.builtins.diagnostics.selene,
            null_ls.builtins.formatting.stylua,
            -- others
            null_ls.builtins.diagnostics.ansiblelint,
            null_ls.builtins.diagnostics.buildifier,
            -- null_ls.builtins.diagnostics.eslint,
            null_ls.builtins.diagnostics.hadolint,
            null_ls.builtins.formatting.buildifier,
            require('none-ls.formatting.jq'),
            null_ls.builtins.formatting.remark,
            null_ls.builtins.formatting.prettier.with({
              disabled_filetypes = { 'markdown' },
            }),
            null_ls.builtins.formatting.qmlformat,
            null_ls.builtins.formatting.packer,
            jsonnetfmt,
          }
          if vim.fn.executable('textlint') ~= 0 then
            table.insert(null_ls_sources, null_ls.builtins.diagnostics.textlint)
          end
          null_ls.setup({
            sources = null_ls_sources,
          })
        end,
      },
      {
        'j-hui/fidget.nvim',
        tag = 'legacy',
        opts = {},
      },
      {
        'glepnir/lspsaga.nvim',
        dependencies = {
          { 'nvim-tree/nvim-web-devicons' },
          { 'nvim-treesitter/nvim-treesitter' },
        },
        event = 'LspAttach',
        opts = {
          lightbulb = {
            virtual_text = false,
          },
        },
      },
      {
        'lvimuser/lsp-inlayhints.nvim',
        opts = {
          inlay_hints = {
            parameter_hints = {
              show = true,
              prefix = ' « ',
              separator = ', ',
            },
          },
        },
      },
    },
    config = function()
      require('user.lsp').setup()
    end,
  },
  {
    'akinsho/flutter-tools.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim',
    },
    opts = {},
  },
  -- cmp
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'onsails/lspkind-nvim',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-cmdline',
      'rcarriga/cmp-dap',
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<Down>'] = cmp.mapping.select_next_item(),
          ['<Up>'] = cmp.mapping.select_prev_item(),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ['<C-j>'] = cmp.mapping.close(),
        }),
        sources = cmp.config.sources({
          { name = 'copilot' },
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'path' },
        }),
        formatting = {
          format = require('lspkind').cmp_format({
            mode = 'symbol_text',
            maxwidth = 100,
            menu = {
              nvim_lsp = '[lsp]',
              nvim_lsp_signature_help = '[signature]',
              path = '[path]',
              buffer = '[buffer]',
            },
            symbol_map = { Copilot = '' },
          }),
        },
      })
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' },
        },
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          { name = 'cmdline' },
        }),
      })
      cmp.setup.filetype({ 'dap-repl', 'dapui_watches' }, {
        sources = {
          { name = 'dap' },
        },
      })
    end,
  },
  -- dap
  {
    'mfussenegger/nvim-dap',
    event = 'VeryLazy',
    dependencies = {
      {
        'rcarriga/nvim-dap-ui',
        dependencies = { 'nvim-neotest/nvim-nio' },
        config = function()
          local dap, dapui = require('dap'), require('dapui')
          dapui.setup({
            commented = true,
          })
          dap.listeners.after.event_initialized['dapui_config'] = function()
            dapui.open({})
          end
          dap.listeners.before.event_terminated['dapui_config'] = function()
            dapui.close({})
          end
          dap.listeners.before.event_exited['dapui_config'] = function()
            dapui.close({})
          end
        end,
      },
      {
        'theHamsta/nvim-dap-virtual-text',
        config = function()
          require('nvim-dap-virtual-text').setup({})
          vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939', bg = '#31353f' })
          vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#31353f' })
          vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = '#31353f' })
          vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
          vim.fn.sign_define('DapBreakpointCondition', { text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
          vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
          vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
          vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })
        end,
      },
    },
    keys = {
      {
        '<F5>',
        function()
          require('dap').continue()
        end,
        desc = 'Continue',
      },
      {
        '<F9>',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Toggle breakpoint',
      },
      {
        '<F10>',
        function()
          require('dap').step_over()
        end,
        desc = 'Step over',
      },
      {
        '<F11>',
        function()
          require('dap').step_into()
        end,
        desc = 'Step into',
      },
      {
        '<F12>',
        function()
          require('dap').step_out()
        end,
        desc = 'Step out',
      },
    },
    config = function()
      local dap = require('dap')
      dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/lldb-vscode',
        name = 'lldb',
      }
      dap.configurations.cpp = {
        {
          name = 'Launch',
          type = 'lldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
        },
      }
      dap.configurations.c = dap.configurations.cpp
    end,
  },
  -- fern
  {
    'lambdalisue/fern.vim',
    cmd = 'Fern',
    dependencies = {
      { 'lambdalisue/fern-renderer-nerdfont.vim', dependencies = 'lambdalisue/nerdfont.vim' },
    },
    init = function()
      vim.g.loaded_netrwPlugin = 1
      vim.g['fern#renderer'] = 'nerdfont'
      vim.api.nvim_create_autocmd('VimEnter', {
        group = vim.api.nvim_create_augroup('startpage', {}),
        nested = true,
        callback = function()
          if vim.fn.argc() == 0 then
            vim.cmd.Fern('.')
          end
        end,
      })
    end,
  },
  'lambdalisue/fern-hijack.vim',
  -- copilot
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    opts = {
      filetypes = {
        ['*'] = true,
      },
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },
  {
    'zbirenbaum/copilot-cmp',
    dependencies = { 'zbirenbaum/copilot.lua' },
    opts = {},
  },
}

local function setup()
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
  require('lazy').setup(config)
end

setup()
