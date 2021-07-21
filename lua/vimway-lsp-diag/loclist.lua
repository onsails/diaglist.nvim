local M = {
  debug = false,
}

function M.lsp_diagnostics_hook()
  -- FIXME: check foreign loclist
  local errors = vim.lsp.diagnostic.get_count(0, "Error")
  local warnings = vim.lsp.diagnostic.get_count(0, "Warning")

  print('total errors' .. errors .. ' warnings ' .. warnings)

  if warnings + errors > 0 then
    vim.lsp.diagnostic.set_loclist({
      open_loclist = false,
      severity_limit = "Warning",
    })
  else
    -- print('no')
    -- if vim.fn.win_gettype() == "" then
    --   vim.cmd("silent! lclose")
    -- end
  end
end

function M.open_buffer_diagnostics()
  M.lsp_diagnostics_hook()
  vim.api.nvim_command [[lopen]]
end

return M
