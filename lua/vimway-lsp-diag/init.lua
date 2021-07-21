local M = {
  debug = false,
}

local q = require('vimway-lsp-diag.quickfix')
local l = require('vimway-lsp-diag.loclist')

function M.init(opts)
  vim.api.nvim_command [[aug lsp_diagnostics]]
  vim.api.nvim_command [[au!]]
  vim.api.nvim_command [[au User LspDiagnosticsChanged lua require("vimway-lsp-diag").lsp_diagnostics_hook()]]
  vim.api.nvim_command [[au WinEnter * lua require("vimway-lsp-diag").lsp_diagnostics_hook()]]
  vim.api.nvim_command [[aug END]]

  vim.api.nvim_command [[aug qf_hook]]
  vim.api.nvim_command [[au!]]
  vim.api.nvim_command [[au! QuickFixCmdPre * lua require("vimway-lsp-diag").quick_fix_hook()]]
  vim.api.nvim_command [[aug END]]

  M.debug = opts ~= nil and opts['debug']
  q.debug = M.debug
end

function M.open_buffer_diagnostics()
  l.open_buffer_diagnostics()
end

function M.open_all_diagnostics()
  q.open_all_diagnostics()
end

function M.lsp_diagnostics_hook()
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
