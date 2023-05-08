local function defer(module)
  return setmetatable({}, {
    __call = function(_, ...)
      require(module)(...)
    end,
  })
end

local function bind(module)
  return setmetatable({}, {
    __index = function(_, method)
      return function(...)
        local args = { ... }
        return function()
          require(module)[method](unpack(args))
        end
      end
    end,
  })
end

local config = {
  'bogado/file-line',
  'tpope/vim-repeat',
  'kana/vim-niceblock',
  'machakann/vim-sandwich',
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function()
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
        ['[b'] = { ':bprevious<CR>', 'Go to previous buffer' },
        [']b'] = { ':bnext<CR>', 'Go to next buffer' },
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
      require('mini.misc').setup({})
      require('mini.sessions').setup({})
      vim.fn.mkdir(require('mini.sessions').config.directory, 'p')
      require('mini.trailspace').setup({})
    end,
  },
  --
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'kyazdani42/nvim-web-devicons', lazy = true },
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
    config = bind('colorizer').setup(),
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    config = bind('gitsigns').setup(),
  },
  {
    'iberianpig/tig-explorer.vim',
    event = 'VeryLazy',
    dependencies = 'rbgrouleff/bclose.vim',
    keys = {
      { '<Leader>T', '<Cmd>TigOpenCurrentFile<CR>' },
      { '<Leader>t', '<Cmd>TigOpenProjectRootDir<CR>' },
    },
  },
  {
    'folke/trouble.nvim',
    event = 'VeryLazy',
    config = bind('trouble').setup(),
  },
  {
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    config = bind('todo-comments').setup(),
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
    config = bind('indent_blankline').setup({
      filetype_exclude = { '', 'help', 'gitcommit', 'lspinfo', 'starter' },
      buftype_exclude = { 'terminal' },
      space_char_blankline = ' ',
      show_current_context = true,
      show_end_of_line = true,
    }),
  },
  {
    'hoob3rt/lualine.nvim',
    event = 'VeryLazy',
    config = function()
      require('lualine').setup({
        options = { theme = 'catppuccin', disabled_filetypes = { 'gundo', 'dap-repl', 'dapui_scopes', 'dapui_breakpoints', 'dapui_stacks', 'dapui_console', 'dapui_watches' } },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = {
            {
              require('lazy.status').updates,
              cond = require('lazy.status').has_updates,
              color = { fg = '#ff9e64' },
            },
            'encoding',
            'fileformat',
            'filetype',
          },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        tabline = { lualine_a = { 'buffers' }, lualine_z = { 'tabs' } },
      })
    end,
  },
  {
    'rcarriga/nvim-notify',
    lazy = true,
    init = function()
      vim.notify = defer('notify')
    end,
  },
  {
    'ahmedkhalf/project.nvim',
    event = { 'BufRead', 'BufNewFile' },
    config = bind('project_nvim').setup(),
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
      'p00f/nvim-ts-rainbow',
      'JoosepAlviste/nvim-ts-context-commentstring',
      'nvim-treesitter/nvim-treesitter-textobjects',
      {
        'nvim-treesitter/nvim-treesitter-context',
        config = bind('treesitter-context').setup(),
      },
      {
        'haringsrob/nvim_context_vt',
        config = bind('nvim_context_vt').setup({ prefix = ' »', disable_virtual_lines = true }),
      },
    },
    build = ':TSUpdate',
    init = function()
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
      vim.opt.foldenable = false
    end,
    config = bind('nvim-treesitter.configs').setup({
      auto_install = true,
      highlight = { enable = true },
      rainbow = { enable = true, extended_mode = true, max_file_lines = nil },
      context_commentstring = { enable = true },
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
    }),
  },
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    keys = {
      {
        '<C-p>',
        bind('telescope.builtin').find_files(),
        desc = 'Find files',
      },
      {
        '<Leader>b',
        bind('telescope.builtin').buffers(),
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
      telescope.load_extension('projects')
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
    config = bind('hlslens').setup(),
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
          'lspsagafinder',
        },
      })
      require('scrollbar.handlers.search').setup()
      require('scrollbar.handlers.gitsigns').setup()
    end,
  },
  { 'RRethy/vim-illuminate', event = 'VeryLazy', config = bind('illuminate').configure({ filetypes_denylist = { 'lspsagafinder' } }) },
  {
    'neovim/nvim-lspconfig',
    event = { 'InsertEnter', 'BufRead' },
    dependencies = {
      {
        'p00f/clangd_extensions.nvim',
        config = function()
          require('clangd_extensions').setup({
            server = {
              cmd = {
                'clangd',
                '--clang-tidy',
                '--header-insertion=never',
                '--completion-style=detailed',
              },
              on_attach = function(client, bufnr)
                require('user.lsp').on_attach(client, bufnr)
                vim.keymap.set('n', 'gs', '<Cmd>ClangdSwitchSourceHeader<CR>', { desc = 'Switch between source/header', buffer = bufnr })
              end,
              capabilities = require('user.lsp').capabilities,
            },
            extensions = { autoSetHints = false, inlay_hints = { parameter_hints_prefix = ' « ', other_hints_prefix = ' » ' } },
          })
        end,
      },
      {
        'jose-elias-alvarez/null-ls.nvim',
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
            null_ls.builtins.code_actions.shellcheck,
            null_ls.builtins.diagnostics.shellcheck,
            null_ls.builtins.diagnostics.zsh,
            null_ls.builtins.formatting.shfmt.with({
              extra_args = { '-i', '2', '-ci' },
            }),
            -- python
            null_ls.builtins.formatting.black,
            null_ls.builtins.diagnostics.mypy.with({
              extra_args = { '--strict' },
            }),
            null_ls.builtins.diagnostics.flake8.with({
              extra_args = { '--max-line-length=88', '--extend-ignore=E203' },
            }),
            null_ls.builtins.formatting.isort.with({
              extra_args = { '--profile=black', '--line-length=88' },
            }),
            -- lua
            null_ls.builtins.diagnostics.luacheck.with({
              extra_args = { '--globals', 'vim' },
            }),
            null_ls.builtins.formatting.stylua,
            -- others
            null_ls.builtins.diagnostics.ansiblelint,
            null_ls.builtins.diagnostics.buildifier,
            null_ls.builtins.diagnostics.cmake_lint,
            null_ls.builtins.diagnostics.eslint,
            null_ls.builtins.diagnostics.hadolint,
            null_ls.builtins.formatting.buildifier,
            null_ls.builtins.formatting.jq,
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
            on_attach = require('user.lsp').on_attach,
            sources = null_ls_sources,
          })
        end,
      },
      {
        'j-hui/fidget.nvim',
        config = bind('fidget').setup(),
      },
      {
        'glepnir/lspsaga.nvim',
        config = function()
          require('lspsaga').setup({
            lightbulb = {
              sign = false,
            },
          })
        end,
      },
      { 'lvimuser/lsp-inlayhints.nvim', config = bind('lsp-inlayhints').setup({
        inlay_hints = {
          parameter_hints = {
            show = true,
            prefix = ' « ',
            separator = ', ',
          },
        },
      }) },
    },
    config = bind('user.lsp').setup(),
  },
  -- cmp
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      {
        'hrsh7th/vim-vsnip',
        dependencies = {
          'hrsh7th/vim-vsnip-integ',
          'rafamadriz/friendly-snippets',
        },
        config = function()
          vim.cmd([[
            imap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
            smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
            imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
            smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
          ]])
        end,
      },
      'onsails/lspkind-nvim',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-cmdline',
      'rcarriga/cmp-dap',
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
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
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'path' },
        }),
        formatting = {
          format = require('lspkind').cmp_format({
            mode = 'symbol_text',
            maxwidth = 100,
            menu = {
              nvim_lsp = '[lsp]',
              vsnip = '[vsnip]',
              nvim_lsp_signature_help = '[signature]',
              path = '[path]',
              buffer = '[buffer]',
            },
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
      { '<F5>', bind('dap').continue(), desc = 'Continue' },
      { '<F9>', bind('dap').toggle_breakpoint(), desc = 'Toggle breakpoint' },
      { '<F10>', bind('dap').step_over(), desc = 'Step over' },
      { '<F11>', bind('dap').step_into(), desc = 'Step into' },
      { '<F12>', bind('dap').step_out(), desc = 'Step out' },
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
