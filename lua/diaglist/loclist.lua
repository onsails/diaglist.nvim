local util = require('diaglist.util')

local M = {
  debug = false,
}

function is_open()
  return vim.fn.getloclist(0, {winid = 0}).winid ~= 0
end

local function get_as_qfitems()
  local all_diags = vim.diagnostic.get(0)
end


function M.diagnostics_hook()
  -- if vim.fn.win_gettype(0) == 'loclist' then
  --   if M.debug then
  --     print('loclist is focused, not updating')
  --   end
  --   return
  -- end
  -- FIXME: check foreign loclist
  vim.diagnostic.setloclist({
    open = false,
  })
end

function M.open_buffer_diagnostics()
  M.diagnostics_hook()
  vim.api.nvim_command [[lw]]
end

return M
