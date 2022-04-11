local opts = {noremap = true, silent = true}
vim.api.nvim_set_keymap('n', '<leader>e',
                        '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>',
                        opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>',
                        opts)
vim.api.nvim_set_keymap('n', '<leader>q',
                        '<cmd>Telescope diagnostics bufnr=0<CR>', opts)

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD',
                              '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd',
                              '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',
                              '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi',
                              '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>',
                              '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa',
                              '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',
                              opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr',
                              '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
                              opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl',
                              '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
                              opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D',
                              '<cmd>Telescope lsp_type_definitions<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn',
                              '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca',
                              '<cmd>Telescope lsp_code_actions<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr',
                              '<cmd>Telescope lsp_references<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f',
                              '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<CR>',
                              '<cmd>Telescope lsp_definitions<CR>', opts)

  if client.resolved_capabilities.document_formatting then
    vim.cmd(
        'call system("git shortlog -se HEAD | grep $(git config user.email)")')
    if vim.v.shell_error == 0 then
      vim.api.nvim_exec([[
        augroup autoformat
          autocmd! * <buffer>
          autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
        augroup END
      ]], false)
    end
  end

  if client.resolved_capabilities.document_range_formatting then
    vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>f',
                                '<cmd>lua vim.lsp.buf.range_formatting()<CR>',
                                opts)
  end

  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

local function format(diagnostic)
  local code = diagnostic.code or
                   (diagnostic.user_data and diagnostic.user_data.lsp and
                       diagnostic.user_data.lsp.code)
  if code then return diagnostic.message .. ' [' .. code .. ']' end
  return diagnostic.message
end
vim.diagnostic.config({
  virtual_text = {source = "if_many", format = format},
  float = {source = "if_many", format = format}
})

local lspconfig = require('lspconfig')
lspconfig.cmake.setup {on_attach = on_attach}
lspconfig.rls.setup {on_attach = on_attach}
lspconfig.vimls.setup {on_attach = on_attach}
lspconfig.pylsp.setup {on_attach = on_attach}
lspconfig.efm.setup {
  filetypes = {'bzl', 'dockerfile', 'json', 'lua', 'markdown', 'sh', 'zsh'},
  on_attach = on_attach
}

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
lspconfig.sumneko_lua.setup {
  settings = {
    Lua = {
      runtime = {version = 'LuaJIT', path = runtime_path},
      diagnostics = {globals = {'vim'}},
      workspace = {library = vim.api.nvim_get_runtime_file("", true)},
      telemetry = {enable = false}
    }
  },
  on_attach = on_attach
}

require("clangd_extensions").setup {
  server = {
    cmd = {
      'clangd', '--clang-tidy', '--header-insertion=never',
      '--completion-style=detailed'
    },
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gs',
                                  '<Cmd>ClangdSwitchSourceHeader<CR>', opts)
    end
  },
  extensions = {inlay_hints = {parameter_hints_prefix = ' <- '}}
}

local cmp = require 'cmp'
cmp.setup({
  snippet = {expand = function() end},
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    },
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item()
  },
  sources = {{name = 'nvim_lsp'}, {name = 'path'}, {name = 'buffer'}}
})
