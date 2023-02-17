local g = vim.api.nvim_create_augroup('filetype', {})

local function set_filetype(config)
  for pattern, fn in pairs(config) do
    vim.api.nvim_create_autocmd('FileType', {
      group = g,
      pattern = pattern,
      callback = fn,
    })
  end
end

local function set_commentstring(config)
  for pattern, commentstring in pairs(config) do
    vim.api.nvim_create_autocmd('FileType', {
      group = g,
      pattern = pattern,
      callback = function()
        vim.bo.commentstring = commentstring
      end,
    })
  end
end

local function setup()
  vim.filetype.add({
    extension = {
      pbtxt = 'proto',
      tf = 'terraform',
      tfvars = 'terraform',
    },
    filename = {
      ['.clang-tidy'] = 'yaml',
      ['.textlintrc'] = 'json',
    },
    pattern = {
      ['tmux.*%.conf'] = 'tmux',
      ['%.gitconfig.*'] = 'gitconfig',
    },
  })

  set_commentstring({ [{ 'c', 'cpp', 'java' }] = '// %s', [{ 'terraform' }] = '# %s' })
  set_filetype({
    gitconfig = function()
      vim.bo.expandtab = false
    end,
    ['*'] = function()
      vim.opt.formatoptions:remove({ 'c', 'r', 'o' })
    end,
  })
end

setup()
