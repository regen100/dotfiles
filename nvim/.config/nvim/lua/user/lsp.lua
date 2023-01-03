local M = {}

vim.fn.system('git shortlog -se HEAD | grep $(git config user.email)')
local own_code = vim.v.shell_error == 0

local function on_attach(client, bufnr)
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
    vim.cmd([[
      augroup autoformat
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
      augroup END
    ]])
  end

  require('illuminate').on_attach(client)
end

local function diagnostic_message(diagnostic)
  local code = diagnostic.code or (diagnostic.user_data and diagnostic.user_data.lsp and diagnostic.user_data.lsp.code)
  if code then
    return diagnostic.message .. ' [' .. code .. ']'
  end
  return diagnostic.message
end

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

function M.setup()
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Goto previous diagnostic' })
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Goto next diagnostic' })
  vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostics' })
  vim.keymap.set('n', '<Leader>q', '<Cmd>Telescope diagnostics bufnr=0<CR>', { desc = 'List diagnostics' })

  vim.diagnostic.config({
    virtual_text = { source = 'if_many', format = diagnostic_message },
    float = { source = 'if_many', format = diagnostic_message },
  })

  vim.cmd.packadd('cmp-nvim-lsp')
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  local lspconfig = require('lspconfig')
  lspconfig.cmake.setup({ on_attach = on_attach, capabilities = capabilities })
  lspconfig.vimls.setup({ on_attach = on_attach, capabilities = capabilities })
  -- lspconfig.pylsp.setup({ on_attach = on_attach, capabilities = capabilities })
  lspconfig.jedi_language_server.setup({ on_attach = on_attach, capabilities = capabilities })
  lspconfig.terraformls.setup({ on_attach = on_attach, capabilities = capabilities })
  lspconfig.tflint.setup({ on_attach = on_attach, capabilities = capabilities })
  lspconfig.tsserver.setup({})

  lspconfig.sumneko_lua.setup({
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT', path = runtime_path },
        diagnostics = { globals = { 'vim' } },
        workspace = { library = vim.api.nvim_get_runtime_file('', true) },
        telemetry = { enable = false },
      },
    },
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      on_attach(client, bufnr)
    end,
    capabilities = capabilities,
  })

  require('clangd_extensions').setup({
    server = {
      cmd = {
        'clangd',
        '--clang-tidy',
        '--header-insertion=never',
        '--completion-style=detailed',
      },
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        vim.keymap.set('n', 'gs', '<Cmd>ClangdSwitchSourceHeader<CR>', { desc = 'Switch between source/header', buffer = bufnr })
      end,
      capabilities = capabilities,
    },
    extensions = { inlay_hints = { parameter_hints_prefix = ' « ', other_hints_prefix = ' » ' } },
  })

  require('rust-tools').setup({
    tools = {
      inlay_hints = {
        parameter_hints_prefix = ' « ',
        other_hints_prefix = ' » ',
      },
    },
    server = {
      on_attach = on_attach,
      capabilities = capabilities,
    },
  })

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
    null_ls.builtins.diagnostics.mypy,
    null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.formatting.isort,
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
    jsonnetfmt,
  }
  if vim.fn.executable('textlint') ~= 0 then
    table.insert(null_ls_sources, null_ls.builtins.diagnostics.textlint)
  end
  null_ls.setup({
    on_attach = on_attach,
    sources = null_ls_sources,
  })

  local win = require('lspconfig.ui.windows')
  local _default_opts = win.default_opts
  win.default_opts = function(options)
    local ret = _default_opts(options)
    ret.border = 'single'
    return ret
  end

  local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
end

return M
