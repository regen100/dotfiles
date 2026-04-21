local set_commentstring = function(cfg)
  for pattern, commentstring in pairs(cfg) do
    vim.api.nvim_create_autocmd("FileType", {
      pattern = pattern,
      callback = function()
        vim.bo.commentstring = commentstring
      end,
    })
  end
end

set_commentstring({
  [{ "c", "cpp", "java" }] = "// %s",
  [{ "terraform" }] = "# %s",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitconfig",
  callback = function()
    vim.bo.expandtab = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.spell = false
  end,
})

local autosave = vim.api.nvim_create_augroup("user_autosave", {})
vim.api.nvim_create_autocmd({ "InsertLeave", "BufLeave", "TextChanged" }, {
  group = autosave,
  callback = function()
    if vim.fn.filereadable(vim.fn.expand("%:p")) == 0 then
      return
    end
    if not vim.opt.modifiable:get() then
      return
    end
    vim.cmd("silent! noautocmd w")
  end,
})

local restoreview = vim.api.nvim_create_augroup("user_restoreview", {})
vim.api.nvim_create_autocmd("BufWinLeave", {
  group = restoreview,
  callback = function()
    if vim.bo.filetype == "gitcommit" then
      return
    end
    vim.cmd("silent! mkview")
  end,
})
vim.api.nvim_create_autocmd("BufEnter", {
  group = restoreview,
  command = "silent! loadview",
})

local function ime_escape(str)
  if vim.env.TMUX then
    str = "\x1BPtmux;" .. string.gsub(str, "\x1B", "\x1B\x1B") .. "\x1B\\"
  end
  return str
end

local restoreimu = vim.api.nvim_create_augroup("user_restoreimu", {})
vim.fn.chansend(vim.v.stderr, ime_escape("\x1B[<0t\x1B[<s"))
vim.api.nvim_create_autocmd("InsertEnter", {
  group = restoreimu,
  callback = function()
    vim.fn.chansend(vim.v.stderr, ime_escape("\x1B[<r"))
  end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = restoreimu,
  callback = function()
    vim.fn.chansend(vim.v.stderr, ime_escape("\x1B[<s\x1B[<0t"))
  end,
})
vim.api.nvim_create_autocmd("VimLeave", {
  group = restoreimu,
  callback = function()
    vim.fn.chansend(vim.v.stderr, ime_escape("\x1B[<0t\x1B[<s"))
  end,
})
