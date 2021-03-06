local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = {noremap = true, silent = true}
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<Leader>wa',
                 '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<Leader>wr',
                 '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<Leader>wl',
                 '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
                 opts)
  buf_set_keymap('n', '<Leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>',
                 opts)
  buf_set_keymap('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<Leader>e',
                 '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<Leader>q',
                 '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  if client.resolved_capabilities.document_formatting then
    buf_set_keymap('n', '<Leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>',
                   opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap('v', '<Leader>f',
                   '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
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
    hi LspDiagnosticsDefaultError  guifg=lightred
    hi LspDiagnosticsDefaultWarning  guifg=lightyellow
  ]], false)

  require'lsp_signature'.on_attach()
end

local lspconfig = require 'lspconfig'
local configs = require 'lspconfig/configs'
if not lspconfig.pysen then
  configs.pysen = {
    default_config = {
      cmd = {'pysen_language_server', '--io'},
      filetypes = {'python'},
      root_dir = lspconfig.util.root_pattern('pyproject.toml')
    }
  }
end

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
lspconfig.pyls.setup {on_attach = on_attach}
lspconfig.pysen.setup {on_attach = on_attach}

vim.o.completeopt = 'menuone,noselect'
require'compe'.setup {
  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    vsnip = false
  }
}

vim.lsp.handlers['textDocument/publishDiagnostics'] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
                 {virtual_text = {prefix = '!', update_in_insert = false}})
