local M = {
  debug = false,
  debounce_ms = 50,
  buf_clients_only = true,
}

local q = require('diaglist.quickfix')
local l = require('diaglist.loclist')

function M.init(opts)
  vim.api.nvim_command [[aug lsp_diagnostics]]
  vim.api.nvim_command [[au!]]
  vim.api.nvim_command [[au User LspDiagnosticsChanged lua require("diaglist").lsp_diagnostics_hook(true)]]
  vim.api.nvim_command [[au WinEnter * lua require("diaglist").lsp_diagnostics_hook(false)]]
  vim.api.nvim_command [[au BufEnter * lua require("diaglist").lsp_diagnostics_hook(false)]]
  vim.api.nvim_command [[aug END]]

  vim.api.nvim_command [[aug qf_hook]]
  vim.api.nvim_command [[au!]]
  vim.api.nvim_command [[au! QuickFixCmdPre * lua require("diaglist").quick_fix_hook()]]
  vim.api.nvim_command [[aug END]]

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

function M.lsp_diagnostics_hook(diag_changed)
  if M.debug then
    if diag_changed then
      print("diagnostics changed")
    else
      print("winenter hook")
    end
  end
  l.lsp_diagnostics_hook()
  q.lsp_diagnostics_hook()
end

function M.quick_fix_hook()
  if M.debug then
    print("foreign quickfix populated, setting flag")
  end
  q.foreign_qf = true
end


return M
