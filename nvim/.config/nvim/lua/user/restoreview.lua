local function setup()
  local g = vim.api.nvim_create_augroup('restoreview', {})
  vim.api.nvim_create_autocmd('BufWinLeave', {
    group = g,
    callback = function()
      if vim.bo.filetype == 'gitcommit' then
        return
      end
      vim.cmd('silent! mkview')
    end,
  })
  vim.api.nvim_create_autocmd('BufEnter', {
    group = g,
    command = 'silent! loadview',
  })
end

setup()
