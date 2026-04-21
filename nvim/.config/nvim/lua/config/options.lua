vim.opt.clipboard = "unnamedplus"

if vim.fn.executable("xclip") ~= 0 and vim.env.DISPLAY then
  vim.g.clipboard = {
    name = "xclip",
    copy = {
      ["+"] = { "xclip", "-quiet", "-i", "-selection", "clipboard" },
      ["*"] = { "xclip", "-quiet", "-i", "-selection", "primary" },
    },
    paste = {
      ["+"] = { "sh", "-c", "xclip -o -selection clipboard | sed s/\\r//g" },
      ["*"] = { "sh", "-c", "xclip -o -selection primary | sed s/\\r//g" },
    },
    cache_enabled = true,
  }
end

vim.opt.relativenumber = false
vim.opt.conceallevel = 0
vim.opt.scrolloff = 3
vim.opt.showmatch = true
vim.opt.softtabstop = 2
vim.opt.showbreak = "↳"
vim.opt.listchars:append({ eol = "↲", extends = "»", precedes = "«" })
vim.opt.matchpairs:append({ "<:>" })
vim.opt.viewoptions = { "cursor", "folds", "slash", "unix" }
vim.opt.guicursor:append({ "c:ver25" })

vim.filetype.add({
  extension = {
    pbtxt = "proto",
    tf = "terraform",
    tfvars = "terraform",
  },
  filename = {
    [".textlintrc"] = "json",
  },
  pattern = {
    ["%.gitconfig.*"] = "gitconfig",
    [".*%.(%a+)%.mako"] = function(_, _, ext)
      return ext
    end,
  },
})
