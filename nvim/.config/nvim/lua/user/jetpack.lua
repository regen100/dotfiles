local M = {}

local installed = false

function M.install()
  if installed then
    return
  end

  local root = vim.fn.stdpath('data') .. '/site/pack/jetpack'
  local src = root .. '/src/vim-jetpack'
  if vim.fn.empty(vim.fn.glob(src)) > 0 then
    vim.fn.system({
      'git',
      'clone',
      '--depth',
      '1',
      'https://github.com/tani/vim-jetpack.git',
      src,
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

  local jetpack = require('jetpack')
  jetpack.startup(function(use_org)
    local function use(config)
      if type(config) == 'table' and config['config'] then
        table.insert(hooks, config['config'])
        config['config'] = nil
      end
      use_org(config)
    end

    fn(use)
  end)

  for _, name in ipairs(jetpack.names()) do
    if not jetpack.tap(name) then
      jetpack.sync()
      break
    end
  end

  for _, hook in ipairs(hooks) do
    if type(hook) == 'function' then
      hook()
    elseif type(hook) == 'string' then
      vim.cmd(hook)
    end
  end
end

return M
