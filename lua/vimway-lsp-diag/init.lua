local M = {
  debug = false,
}

local q = require('vimway-lsp-diag.quickfix')
local l = require('vimway-lsp-diag.loclist')

function M.init(opts)
  vim.api.nvim_command [[aug lsp_diagnostics]]
  vim.api.nvim_command [[au!]]
  vim.api.nvim_command [[au User LspDiagnosticsChanged lua require("vimway-lsp-diag").lsp_diagnostics_hook(true)]]
  vim.api.nvim_command [[au WinEnter * lua require("vimway-lsp-diag").lsp_diagnostics_hook(false)]]
  vim.api.nvim_command [[au BufEnter * lua require("vimway-lsp-diag").lsp_diagnostics_hook(false)]]
  vim.api.nvim_command [[aug END]]

  vim.api.nvim_command [[aug qf_hook]]
  vim.api.nvim_command [[au!]]
  vim.api.nvim_command [[au! QuickFixCmdPre * lua require("vimway-lsp-diag").quick_fix_hook()]]
  vim.api.nvim_command [[aug END]]

  M.debug = opts ~= nil and opts['debug']
  M.debounce_ms = opts ~= nil and opts['debounce_ms']

  q.debug = M.debug
  l.debug = M.debug
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
