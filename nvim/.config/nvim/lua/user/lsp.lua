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

function M.on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local telescope = require('telescope.builtin')
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Display hover information', buffer = bufnr })
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Display signature information', buffer = bufnr })
  vim.keymap.set('n', '<CR>', telescope.lsp_definitions, { desc = 'Goto the definition', buffer = bufnr })
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Goto the declaration', buffer = bufnr })
  vim.keymap.set('n', 'gd', telescope.lsp_definitions, { desc = 'Goto the definition', buffer = bufnr })
  vim.keymap.set('n', 'gi', telescope.lsp_implementations, { desc = 'Goto the implementations', buffer = bufnr })
  vim.keymap.set('n', 'gr', telescope.lsp_references, { desc = 'Goto the references', buffer = bufnr })
  vim.keymap.set('n', 'gt', telescope.lsp_type_definitions, { desc = 'Goto the definition of the type', buffer = bufnr })
  vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, { desc = 'Rename', buffer = bufnr })
  vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, { desc = 'Code actions', buffer = bufnr })
  vim.keymap.set('n', '<Leader>f', function()
    vim.lsp.buf.format({ async = true })
  end, { desc = 'Format', buffer = bufnr })

  if client.server_capabilities.documentFormattingProvider and own_code then
    local g = vim.api.nvim_create_augroup('autoformat', { clear = false })
    vim.api.nvim_clear_autocmds({ group = g, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = g,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
  end
end

M.capabilities = require('cmp_nvim_lsp').default_capabilities()

local function default(config)
  config = config or {}
  config.capabilities = config.capabilities or M.capabilities
  if config.on_attach then
    local fn = config.on_attach
    config.on_attach = function(...)
      fn(...)
      M.on_attach(...)
    end
  else
    config.on_attach = M.on_attach
  end
  return config
end

function M.setup()
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
  lspconfig.cmake.setup(default())
  lspconfig.vimls.setup(default())
  lspconfig.jedi_language_server.setup(default())
  lspconfig.terraformls.setup(default())
  lspconfig.tflint.setup(default())
  lspconfig.tsserver.setup(default())
  lspconfig.sumneko_lua.setup(default({
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
  }))
end

return M
