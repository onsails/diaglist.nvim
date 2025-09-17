local M = {
  debug = false,
  buf_clients_only = true,
  debounce_ms = 150,
}

local q = require('diaglist.quickfix')
local l = require('diaglist.loclist')

function M.init(opts)
  local aug_id = vim.api.nvim_create_augroup('diagnostics', {})
  vim.api.nvim_create_autocmd('DiagnosticChanged', {
    group = aug_id,
    pattern = '*',
    callback = function()
      require('diaglist').diagnostics_hook(true)
    end,
  })
  vim.api.nvim_create_autocmd('WinEnter', {
    group = aug_id,
    pattern = '*',
    callback = function()
      require('diaglist').diagnostics_hook(false)
    end,
  })
  vim.api.nvim_create_autocmd('BufEnter', {
    group = aug_id,
    pattern = '*',
    callback = function()
      require('diaglist').diagnostics_hook(false)
    end,
  })

  if opts == nil then
    opts = {}
  end

  if opts['debug'] ~= nil then
    M.debug = opts['debug']
  end

  q.debug = M.debug
  l.debug = M.debug

  if opts['debounce_ms'] ~= nil then
    M.debounce_ms = opts['debounce_ms']
  end

  q.debounce_ms = M.debounce_ms
  if M.debug then
    print(q.debounce_ms)
  end

  if opts['buf_clients_only'] ~= nil then
    M.buf_clients_only = opts['buf_clients_only']
  end

  q.buf_clients_only = M.buf_clients_only

  q.init()
end

function M.open_buffer_diagnostics()
  l.open_buffer_diagnostics()
end

function M.open_all_diagnostics()
  q.open_all_diagnostics()
end

function M.diagnostics_hook(diag_changed)
  if M.debug then
    if diag_changed then
      print("diagnostics changed")
    else
      print("winenter hook")
    end
  end
  l.diagnostics_hook()
  q.diagnostics_hook()
end

return M
