vim.g.load_black = 1
vim.g.loaded_fzf = 1

vim.g.mapleader = ' '

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.wrap = false
vim.opt.list = true
vim.opt.listchars:append({ eol = '↲', extends = '»', precedes = '«' })
vim.opt.matchpairs:append({ '<:>' })
vim.opt.mouse = 'a'
vim.opt.scrolloff = 3
vim.opt.showbreak = '↳'
vim.opt.showmatch = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.splitbelow = true
vim.opt.virtualedit = 'block'
vim.opt.termguicolors = true
vim.opt.pumblend = 10
vim.opt.undofile = true
vim.opt.clipboard:append({ 'unnamedplus' })
vim.opt.viewoptions = { 'cursor', 'folds', 'slash', 'unix' }
vim.opt.guicursor:append({ 'c:ver25' })
vim.opt.cmdheight = 0
vim.opt.signcolumn = 'yes'

if vim.fn.executable('xclip') ~= 0 then
  vim.g.clipboard = {
    name = 'xclip',
    copy = {
      ['+'] = { 'xclip', '-quiet', '-i', '-selection', 'clipboard' },
      ['*'] = { 'xclip', '-quiet', '-i', '-selection', 'primary' },
    },
    paste = {
      ['+'] = { 'sh', '-c', 'xclip -o -selection clipboard | sed s/\r//g' },
      ['*'] = { 'sh', '-c', 'xclip -o -selection primary | sed s/\r//g' },
    },
    cache_enabled = true,
  }
end

vim.api.nvim_create_autocmd('InsertLeave', {
  group = vim.api.nvim_create_augroup('vimrc', {}),
  callback = function()
    vim.opt.paste = false
  end,
})

require('user.plugin')
require('user.filetype')
require('user.autosave')
require('user.restoreview')
require('user.restoreimu')

vim.opt.secure = true
