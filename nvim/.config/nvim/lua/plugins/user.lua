return {
  { "wsdjeg/vim-fetch", lazy = false },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = { "remark" },
        ["markdown.mdx"] = { "remark" },
      },
    },
  },

  { "jghauser/mkdir.nvim", event = "BufWritePre" },

  { "kana/vim-niceblock", event = "VeryLazy" },

  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  {
    "jiaoshijie/undotree",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>U",
        function()
          require("undotree").toggle()
        end,
        desc = "Undotree",
      },
    },
    opts = {},
  },

  {
    "lambdalisue/suda.vim",
    cmd = { "SudaRead", "SudaWrite" },
    init = function()
      vim.cmd.cabbrev("w!!", "SudaWrite")
    end,
  },

  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("illuminate").configure({
        filetypes_denylist = { "neo-tree", "Trouble", "notify", "lazy", "mason", "help" },
      })
    end,
  },

  {
    "kevinhwang91/nvim-hlslens",
    keys = {
      { "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]] },
      { "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]] },
      { "*", [[*<Cmd>lua require('hlslens').start()<CR>]] },
      { "#", [[#<Cmd>lua require('hlslens').start()<CR>]] },
      { "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]] },
      { "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]] },
    },
    opts = {},
  },
}
