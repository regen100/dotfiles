M = {}

function M.save()
  if vim.fn.filereadable(vim.fn.expand('%:p')) == 0 then return end
  if not vim.opt.modifiable:get() then return end
  vim.cmd('silent! noautocmd w')
end

function M.setup()
  vim.cmd [[
    augroup autosave
      autocmd!
      autocmd InsertLeave,BufLeave,TextChanged * lua require('user.autosave').save()
    augroup END
  ]]
end

return M
