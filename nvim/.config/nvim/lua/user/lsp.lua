vim.fn.system('git shortlog -se HEAD | grep $(git config user.email)')
local own_code = vim.v.shell_error == 0

local function diagnostic_message(diagnostic)
  local code = diagnostic.code or (diagnostic.user_data and diagnostic.user_data.lsp and diagnostic.user_data.lsp.code)
  if code then
    return diagnostic.message .. ' [' .. code .. ']'
  end
  return diagnostic.message
end

local M = {}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(args)
    vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    vim.keymap.set('n', 'K', '<Cmd>Lspsaga hover_doc<CR>', { desc = 'Display hover information', buffer = args.buf })
    vim.keymap.set('n', '<CR>', '<Cmd>Lspsaga finder def+tyd+imp<CR>', { desc = 'Show symbol info', buffer = args.buf })
    vim.keymap.set('n', '<Leader>rn', '<Cmd>Lspsaga rename<CR>', { desc = 'Rename', buffer = args.buf })
    vim.keymap.set({ 'n', 'v' }, '<Leader>ca', '<Cmd>Lspsaga code_action<CR>', { desc = 'Code actions', buffer = args.buf })
    vim.keymap.set('n', '[d', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', { desc = 'Goto previous diagnostic', buffer = args.buf })
    vim.keymap.set('n', ']d', '<Cmd>Lspsaga diagnostic_jump_next<CR>', { desc = 'Goto next diagnostic', buffer = args.buf })
    vim.keymap.set('n', '<Leader>e', '<Cmd>Lspsaga show_line_diagnostics<CR>', { desc = 'Show diagnostics', buffer = args.buf })
    vim.keymap.set('n', '<Leader>q', '<Cmd>Telescope diagnostics bufnr=0<CR>', { desc = 'List diagnostics', buffer = args.buf })
    vim.keymap.set('n', '<Leader>f', function()
      vim.lsp.buf.format({ async = true })
    end, { desc = 'Format', buffer = args.buf })

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    assert(client ~= nil)
    if own_code then
      local g = vim.api.nvim_create_augroup('autoformat', { clear = false })
      vim.api.nvim_clear_autocmds({ group = g, buffer = args.buf })
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = g,
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end

    client.server_capabilities = vim.tbl_extend('force', require('cmp_nvim_lsp').default_capabilities(), client.server_capabilities)

    vim.lsp.inlay_hint.enable(true)
  end,
})

function M.setup()
  vim.keymap.set('n', '<Leader>o', '<Cmd>Lspsaga outline<CR>', { desc = 'Show outline' })

  vim.diagnostic.config({
    virtual_text = { source = 'if_many', format = diagnostic_message },
    float = { source = 'if_many', format = diagnostic_message },
  })

  local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  local lspconfig = require('lspconfig')
  lspconfig.cmake.setup({
    on_attach = function(client, _)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  })
  lspconfig.vimls.setup({})
  lspconfig.jedi_language_server.setup({})
  lspconfig.terraformls.setup({})
  lspconfig.tsserver.setup({})
  lspconfig.rust_analyzer.setup({})
  lspconfig.ruff_lsp.setup({})
  lspconfig.bashls.setup({})
  lspconfig.lua_ls.setup({
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        diagnostics = { globals = { 'vim' } },
        workspace = { library = vim.api.nvim_get_runtime_file('', true) },
        telemetry = { enable = false },
      },
    },
    on_attach = function(client, _)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  })
  lspconfig.clangd.setup({
    cmd = {
      'clangd',
      '--clang-tidy',
      '--header-insertion=never',
      '--completion-style=detailed',
    },
    on_attach = function(_, bufnr)
      vim.keymap.set('n', 'gs', '<Cmd>ClangdSwitchSourceHeader<CR>', { desc = 'Switch between source/header', buffer = bufnr })
    end,
  })
  lspconfig.yamlls.setup({
    settings = {
      yaml = {
        schemas = {
          ['https://json.schemastore.org/github-workflow.json'] = '.github/workflows/*',
          ['https://json.schemastore.org/github-action.json'] = '.github/actions/*',
        },
      },
    },
  })
end

return M
