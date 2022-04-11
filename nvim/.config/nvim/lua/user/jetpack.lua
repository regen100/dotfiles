local M = {}

local installed = false

function M.install()
  if installed then return end

  local root = vim.fn.stdpath('data') .. '/site/pack/jetpack'
  local src = root .. '/src/vim-jetpack'
  if vim.fn.empty(vim.fn.glob(src)) > 0 then
    vim.fn.system({
      'git', 'clone', '--depth', '1', 'https://github.com/tani/vim-jetpack.git',
      src
    })
    local opt = root .. '/opt/vim-jetpack'
    vim.fn.mkdir(root .. '/opt', 'p')
    vim.loop.fs_symlink(src, opt)
  end
  vim.g['jetpack#copy_method'] = 'symlink'
  vim.cmd('packadd vim-jetpack')

  installed = true
end

function M.startup(fn)
  M.install()

  local hooks = {}
  local function config(hook) table.insert(hooks, hook) end

  local jetpack = require('jetpack')
  jetpack.startup(function(use) fn(use, config) end)

  for _, name in ipairs(vim.fn['jetpack#names']()) do
    if jetpack.tap(name) == 0 then
      jetpack.sync()
      break
    end
  end

  for _, hook in ipairs(hooks) do hook() end
end

return M
