local lsp = require 'lspconfig'
lsp.cmake.setup {}
lsp.clangd.setup {cmd = {'clangd', '--clang-tidy', '--header-insertion=never'}}
lsp.rust_analyzer.setup {}
lsp.vimls.setup {}
lsp.sumneko_lua.setup {
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
  }
}

vim.o.completeopt = 'menuone,noselect'
require'compe'.setup {
  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    vsnip = true
  }
}
