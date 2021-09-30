local M = {
  debug = false,
}

function M.lsp_diagnostics_hook()
  if vim.api.nvim_buf_get_option(0, 'buftype') == 'quickfix' then
    if M.debug then
      print('loclist is focused, not updating')
    end
    return
  end
  -- FIXME: check foreign loclist
  if vim.lsp.buf.server_ready() then
    vim.lsp.diagnostic.set_loclist({
      open_loclist = false,
      severity_limit = 'Warning',
    })
  else
    -- print('no')
    -- if vim.fn.win_gettype() == '' then
    --   vim.cmd('silent! lclose')
  end
end

function M.open_buffer_diagnostics()
  M.lsp_diagnostics_hook()
  vim.api.nvim_command [[lopen]]
end

return M
