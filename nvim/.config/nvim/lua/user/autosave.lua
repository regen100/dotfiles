local function save()
  if vim.fn.filereadable(vim.fn.expand('%:p')) == 0 then
    return
  end
  if not vim.opt.modifiable:get() then
    return
  end
  vim.cmd('silent! noautocmd w')
end

local function setup()
  local g = vim.api.nvim_create_augroup('autosave', {})
  vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufLeave', 'TextChanged' }, {
    group = g,
    callback = save,
  })
end

setup()
