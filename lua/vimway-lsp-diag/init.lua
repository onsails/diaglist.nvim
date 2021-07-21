local M = {}

local q = require('vimway-lsp-diag.quickfix')
local l = require('vimway-lsp-diag.loclist')

function M.init()
  vim.api.nvim_command [[aug lsp_diagnostics]]
  vim.api.nvim_command [[au!]]
  vim.api.nvim_command [[au User LspDiagnosticsChanged lua require("vimway-lsp-diag").lsp_diagnostics_hook()]]
  vim.api.nvim_command [[aug END]]

  vim.api.nvim_command [[aug qf_hook]]
  vim.api.nvim_command [[au!]]
  vim.api.nvim_command [[au! QuickFixCmdPre * lua require("vimway-lsp-diag").quick_fix_hook()]]
  vim.api.nvim_command [[aug END]]
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

return M
