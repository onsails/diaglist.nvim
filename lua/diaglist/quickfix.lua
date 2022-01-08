local api = vim.api
local lsp = require('vim.lsp')
local util = require('diaglist.util')

local M = {}

M.last_priority_uri = nil
M.title = 'Workspace Diagnostics'

local function is_qf_foreign()
  return vim.fn.getqflist{ title = 0 }.title ~= M.title
end

local function populate_qflist(open_qflist)
  local priority_uri = vim.uri_from_bufnr(0)
  if string.sub(priority_uri,0,7) == 'file://' and string.len(priority_uri) > 7 then
    M.last_priority_uri = priority_uri
  else
    priority_uri = M.last_priority_uri
  end

  local all_diagnostics = util.get_qflist({
    priority_uri = priority_uri,
    bufnr = nil,
  })

  vim.fn.setqflist(all_diagnostics, 'r')
  vim.fn.setqflist({}, 'a', {title = 'Workspace Diagnostics'})
end

M.open_all_diagnostics = function()
  populate_qflist()
  api.nvim_command('copen')
end

M.diagnostics_hook = function()
  if not is_qf_foreign() then
    populate_qflist()
  elseif M.debug then
    print('foreign quickfix, not populating')
  end
end

return M
