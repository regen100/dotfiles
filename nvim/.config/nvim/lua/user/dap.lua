local M = {}

function M.setup()
  local dap = require('dap')
  dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode',
    name = 'lldb',
  }
  dap.configurations.cpp = {
    {
      name = 'Launch',
      type = 'lldb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},
    },
  }
  dap.configurations.c = dap.configurations.cpp

  require('nvim-dap-virtual-text').setup({})

  vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939', bg = '#31353f' })
  vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#31353f' })
  vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = '#31353f' })
  vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
  vim.fn.sign_define('DapBreakpointCondition', { text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
  vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
  vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
  vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })

  local dapui = require('dapui')
  dapui.setup({
    commented = true,
  })
  dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open({})
  end
  dap.listeners.before.event_terminated['dapui_config'] = function()
    dapui.close({})
  end
  dap.listeners.before.event_exited['dapui_config'] = function()
    dapui.close({})
  end

  vim.keymap.set("n", '<F5>', dap.continue, {desc='Continue'})
  vim.keymap.set("n", '<F9>', dap.toggle_breakpoint, {desc='Toggle breakpoint'})
  vim.keymap.set("n", '<F10>',dap.step_over , {desc='Step over'})
  vim.keymap.set("n", '<F11>',dap.step_into , {desc='Step into'})
  vim.keymap.set("n", '<F12>', dap.step_out, {desc='Step out'})
end

return M
