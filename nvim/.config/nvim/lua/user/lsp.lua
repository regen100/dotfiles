local M = {}

local function on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local telescope = require('telescope.builtin')
  require('nest').applyKeymaps {
    buffer = bufnr,
    {
      {'gD', vim.lsp.buf.declaration}, --
      {'gd', vim.lsp.buf.definition}, --
      {'K', vim.lsp.buf.hover}, --
      {'gi', vim.lsp.buf.implementation}, --
      {'<C-k>', vim.lsp.buf.signature_help}, --
      {'gr', telescope.lsp_references}, --
      {'<CR>', telescope.lsp_definitions}, --
      {
        '<Leader>', {
          {'wa', vim.lsp.buf.add_workspace_folder}, --
          {'wr', vim.lsp.buf.remove_workspace_folder}, --
          {
            'wl',
            '<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))'
          }, --
          {'D', telescope.lsp_type_definitions}, --
          {'rn', vim.lsp.buf.rename}, --
          {'ca', telescope.lsp_code_actions}, --
          {'f', vim.lsp.buf.formatting} --
        }
      } --
    }
  }

  if client.resolved_capabilities.document_formatting then
    vim.fn.system('git shortlog -se HEAD | grep $(git config user.email)')
    if vim.v.shell_error == 0 then
      vim.cmd [[
        augroup autoformat
          autocmd! * <buffer>
          autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
        augroup END
      ]]
    end
  end

  require('illuminate').on_attach(client)
end

local function diagnostic_message(diagnostic)
  local code = diagnostic.code or
                   (diagnostic.user_data and diagnostic.user_data.lsp and
                       diagnostic.user_data.lsp.code)
  if code then return diagnostic.message .. ' [' .. code .. ']' end
  return diagnostic.message
end

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

function M.setup()
  require('nest').applyKeymaps {
    {'[d', vim.diagnostic.goto_prev}, --
    {']d', vim.diagnostic.goto_next}, --
    {
      '<Leader>', {
        {'e', vim.diagnostic.open_float}, --
        {'q', '<Cmd>Telescope diagnostics bufnr=0<CR>'} --
      }
    } --
  }

  vim.diagnostic.config {
    virtual_text = {source = 'if_many', format = diagnostic_message},
    float = {source = 'if_many', format = diagnostic_message}
  }

  local lspconfig = require('lspconfig')
  lspconfig.cmake.setup {on_attach = on_attach}
  lspconfig.rls.setup {on_attach = on_attach}
  lspconfig.vimls.setup {on_attach = on_attach}
  lspconfig.pylsp.setup {on_attach = on_attach}
  lspconfig.efm.setup {
    filetypes = {'bzl', 'dockerfile', 'json', 'lua', 'markdown', 'sh', 'zsh'},
    on_attach = on_attach
  }

  lspconfig.sumneko_lua.setup {
    settings = {
      Lua = {
        runtime = {version = 'LuaJIT', path = runtime_path},
        diagnostics = {globals = {'vim'}},
        workspace = {library = vim.api.nvim_get_runtime_file('', true)},
        telemetry = {enable = false}
      }
    },
    on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
      on_attach(client, bufnr)
    end
  }

  require('clangd_extensions').setup {
    server = {
      cmd = {
        'clangd', '--clang-tidy', '--header-insertion=never',
        '--completion-style=detailed'
      },
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        require('nest').applyKeymaps {
          buffer = bufnr,
          {
            {'gs', '<Cmd>ClangdSwitchSourceHeader<CR>'} --
          }
        }
      end
    },
    extensions = {inlay_hints = {parameter_hints_prefix = ' <- '}}
  }

  local cmp = require('cmp')
  cmp.setup {
    snippet = {expand = function() end},
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true
      },
      ['<Tab>'] = cmp.mapping.select_next_item(),
      ['<S-Tab>'] = cmp.mapping.select_prev_item()
    },
    formatting = {
      format = require('lspkind').cmp_format({mode = 'symbol_text'})
    },
    sources = {
      {name = 'nvim_lsp'}, {name = 'path'}, {name = 'buffer'},
      {name = 'nvim_lua'}
    }
  }
  cmp.setup.cmdline(':', {sources = {{name = 'cmdline'}}})
  cmp.setup.cmdline('/', {sources = {{name = 'buffer'}}})

  require('nvim-lightbulb').setup {
    sign = {enabled = false},
    float = {enabled = true}
  }
  vim.cmd [[autocmd vimrc CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()]]

  require('lsp_signature').setup()

  require('fidget').setup()

  local win = require('lspconfig.ui.windows')
  local _default_opts = win.default_opts
  win.default_opts = function(options)
    local ret = _default_opts(options)
    ret.border = 'single'
    return ret
  end

  local signs = {Error = " ", Warn = " ", Hint = " ", Info = " "}
  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
  end
end

return M
