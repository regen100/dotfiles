local util = require('simple-cmp.util')

local M = {}

local default_config = {
  disable_trigger = {},
}

local function setup_config(config)
  vim.validate({ config = { config, 'table', true } })
  config = vim.tbl_deep_extend('force', default_config, config or {})
  vim.validate({ disable_trigger = { config.disable_trigger, 'table' } })
  return config
end

function M.setup(config)
  _G.simple_cmp = M
  M.config = setup_config(config)
  vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }
  vim.cmd([[
    augroup simple-cmp
      autocmd!
      autocmd BufEnter * lua vim.opt.completefunc = 'v:lua.simple_cmp.completefunc'
      autocmd TextChangedI * lua simple_cmp.on_text_changed()
      autocmd CompleteChanged * lua simple_cmp.open_info()
      autocmd CompleteDonePre * lua simple_cmp.close_info()
  ]])
end

local function modify_complete_items(items)
  for _, item in ipairs(items) do
    if not util.is_whitespace(item.menu) then
      -- move menu to info
      item.info = table.concat({ ('`%s`').format(item.menu), item.info }, '\n\n')
      item.menu = ''
    end
  end
end

function M.completefunc()
  local pos = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  local line_to_cursor = line:sub(1, pos[2])
  local textMatch = vim.fn.match(line_to_cursor, '\\k*$')
  local params = vim.lsp.util.make_position_params()

  local items = {}
  vim.lsp.buf_request(0, 'textDocument/completion', params, function(err, result, ctx)
    if err or not result or vim.fn.mode() ~= 'i' then
      return
    end
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local encoding = client and client.offset_encoding or 'utf-16'
    local candidates = vim.lsp.util.extract_completion_items(result)
    local startbyte = util.adjust_start_col(pos[1], line, candidates, encoding) or textMatch
    local prefix = line:sub(startbyte + 1, pos[2])
    local matches = vim.lsp.util.text_document_completion_list_to_complete_items(result, prefix)
    modify_complete_items(matches)
    vim.list_extend(items, matches)
    vim.fn.complete(startbyte + 1, items)
  end)

  return -2
end

local info_win = util.info_win:new()

function M.open_info()
  local event = vim.v.event
  vim.schedule(function()
    info_win:open(event)
  end)
end

function M.close_info()
  info_win:close()
end

local function collect_triggers()
  local clients = vim.lsp.get_active_clients()
  local hash = {}
  for _, client in ipairs(clients) do
    local triggers = client.server_capabilities and client.server_capabilities.completionProvider and client.server_capabilities.completionProvider.triggerCharacters
    if triggers then
      for _, trigger in ipairs(triggers) do
        hash[trigger] = true
      end
    end
  end
  for _, trigger in ipairs(M.config.disable_trigger) do
    hash[trigger] = nil
  end
  return vim.tbl_keys(hash)
end

function M.on_text_changed()
  if vim.fn.pumvisible() ~= 0 then
    return
  end

  local pos = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  local line_to_cursor = line:sub(1, pos[2])
  if util.is_whitespace(line_to_cursor) then
    return
  end
  local triggers = collect_triggers()
  for _, trigger in ipairs(triggers) do
    if vim.endswith(line_to_cursor, trigger) then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-X><C-U>', true, true, true), 'i', false)
    end
  end
end

return M
