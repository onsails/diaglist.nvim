local M = {
  debug = false,
}

function is_open()
  return vim.fn.getloclist(0, {winid = 0}).winid ~= 0
end

function M.diagnostics_hook()

  if vim.api.nvim_buf_get_option(0, 'buftype') == 'quickfix' then
    if M.debug then
      print('loclist is focused, not updating')
    end
    return
  end
  -- FIXME: check foreign loclist
  if vim.lsp.buf.server_ready() then
    vim.diagnostic.setloclist({
      open = false,
      severity_limit = 'Warning',
    })
  else
    -- print('no')
    -- if vim.fn.win_gettype() == '' then
    --   vim.cmd('silent! lclose')
  end
end

function M.open_buffer_diagnostics()
  M.diagnostics_hook()
  vim.api.nvim_command [[lw]]
end

return M
