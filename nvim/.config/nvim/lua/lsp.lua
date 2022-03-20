local opts = {noremap = true, silent = true}
vim.api.nvim_set_keymap('n', '<leader>e',
                        '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>',
                        opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>',
                        opts)
vim.api.nvim_set_keymap('n', '<leader>q',
                        '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

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
                              '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn',
                              '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca',
                              '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr',
                              '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f',
                              '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<CR>',
                              '<cmd>lua vim.lsp.buf.definition()<CR>', opts)

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
      hi LspReferenceRead term=underline cterm=underline gui=underline
      hi LspReferenceText term=underline cterm=underline gui=underline
      hi LspReferenceWrite term=underline cterm=underline gui=underline
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end

  vim.api.nvim_exec([[
    hi LspDiagnosticsDefaultError guifg=lightred
    hi LspDiagnosticsDefaultWarning guifg=lightyellow
  ]], false)
end

local lspconfig = require 'lspconfig'

lspconfig.cmake.setup {on_attach = on_attach}
lspconfig.clangd.setup {
  cmd = {'clangd', '--clang-tidy', '--header-insertion=never'},
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gs',
                                '<Cmd>ClangdSwitchSourceHeader<CR>',
                                {noremap = true, silent = true})
  end
}
lspconfig.rls.setup {on_attach = on_attach}
lspconfig.vimls.setup {on_attach = on_attach}
lspconfig.sumneko_lua.setup {
  cmd = {'lua-language-server'},
  settings = {
    Lua = {
      runtime = {version = 'LuaJIT', path = vim.split(package.path, ';')},
      diagnostics = {globals = {'vim'}},
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
        }
      },
      telemetry = {enable = false}
    }
  },
  on_attach = on_attach
}
lspconfig.pylsp.setup {on_attach = on_attach}
lspconfig.efm.setup {
  filetypes = {'bzl', 'json', 'lua', 'markdown', 'sh', 'zsh'},
  on_attach = on_attach
}

vim.lsp.handlers['textDocument/publishDiagnostics'] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
                 {virtual_text = {prefix = '!', update_in_insert = false}})

local cmp = require 'cmp'
cmp.setup({
  mapping = {
    ['<C-y>'] = cmp.mapping.confirm({select = true}),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    },
    ['<Tab>'] = function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(vim.api
                            .nvim_replace_termcodes('<C-n>', true, true, true),
                        'n')
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(vim.api
                            .nvim_replace_termcodes('<C-p>', true, true, true),
                        'n')
      else
        fallback()
      end
    end
  },
  sources = {{name = 'buffer'}, {name = 'nvim_lsp'}, {name = 'path'}}
})
