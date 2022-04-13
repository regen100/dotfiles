local M = {}

--- @see https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp.lua
function M.adjust_start_col(lnum, line, items, encoding)
  local min_start_char = nil
  for _, item in pairs(items) do
    if item.filterText == nil and item.textEdit and item.textEdit.range.start.line == lnum - 1 then
      if min_start_char and min_start_char ~= item.textEdit.range.start.character then
        return nil
      end
      min_start_char = item.textEdit.range.start.character
    end
  end
  if min_start_char then
    return vim.lsp.util._str_byteindex_enc(line, min_start_char, encoding)
  else
    return nil
  end
end

function M.is_whitespace(s)
  return s:find('^%s*$')
end

M.info_win = {}
M.info_win.__index = M.info_win

function M.info_win:new()
  local ret = {}
  setmetatable(ret, self)
  ret.winnr = nil
  return ret
end

function M.info_win:open(event)
  self:close()

  local info = event and event.completed_item and event.completed_item.info
  if not info then
    return
  end

  local pum_x = event.col
  local pum_y = event.row
  local win_y = pum_y - 1
  local pum_w = event.width + (event.scrollbar and 1 or 0)
  local left_space = pum_x - 1
  local right_space = vim.o.columns - pum_w - pum_x - 1
  local win_x, win_w
  if left_space <= right_space then
    win_x = pum_x + pum_w
    win_w = right_space
  else
    win_x = 0
    win_w = left_space
  end

  local bufnr = vim.api.nvim_create_buf(false, true)
  local contents = vim.lsp.util.convert_input_to_markdown_lines(info)
  local opts = { max_width = win_w, wrap_at = win_w }
  contents = vim.lsp.util.stylize_markdown(bufnr, contents, opts)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, contents)
  vim.api.nvim_buf_set_option(bufnr, 'syntax', 'markdown')
  local width, height = vim.lsp.util._make_floating_popup_size(contents, opts)

  self.winnr = vim.api.nvim_open_win(bufnr, false, {
    relative = 'win',
    row = win_y,
    col = win_x,
    width = width,
    height = height,
    style = 'minimal',
  })
  vim.api.nvim_win_set_option(self.winnr, 'wrap', true)
end

function M.info_win:close()
  if self.winnr and vim.api.nvim_win_is_valid(self.winnr) then
    local bufnr = vim.api.nvim_win_get_buf(self.winnr)
    vim.api.nvim_win_close(self.winnr, true)
    vim.cmd('bdelete ' .. bufnr)
  end
  self.winnr = nil
end

return M
