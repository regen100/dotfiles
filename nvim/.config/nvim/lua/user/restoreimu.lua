local function escape(str)
  if vim.env.TMUX then
    str = '\x1BPtmux;' .. string.gsub(str, '\x1B', '\x1B\x1B') .. '\x1B\\'
  end
  return str
end

local function setup()
  vim.fn.chansend(vim.v.stderr, escape('\x1B[<0t\x1B[<s'))
  local g = vim.api.nvim_create_augroup('restoreime', {})
  vim.api.nvim_create_autocmd('InsertEnter', {
    group = g,
    callback = function()
      vim.fn.chansend(vim.v.stderr, escape('\x1B[<r'))
    end,
  })
  vim.api.nvim_create_autocmd('InsertLeave', {
    group = g,
    callback = function()
      vim.fn.chansend(vim.v.stderr, escape('\x1B[<s\x1B[<0t'))
    end,
  })
  vim.api.nvim_create_autocmd('VimLeave', {
    group = g,
    callback = function()
      vim.fn.chansend(vim.v.stderr, escape('\x1B[<0t\x1B[<s'))
    end,
  })
end

setup()
