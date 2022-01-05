local api = vim.api
local lsp = require('vim.lsp')
local debounce_trailing = require('diaglist.debounce').debounce_trailing

local M = {}

-- original function is copied from nvim-metals
-- https://github.com/scalameta/nvim-metals/blob/69a5cf9380defde5be675bd5450e087d59314855/lua/metals/diagnostic.lua
--
-- added current buf problems prioritization
-- added filter for current buf clients
local function get_all_diagnostics_as_qfitems(priority_filename)
  if M.debug then
    print('priority ' .. priority_filename)
  end

  local qfitems = {}
  -- Temporary array for warnings, so they are appended after errors
  local warnings = {}

  local all_diags = {}

  if M.buf_clients_only then
    for _, client in pairs(vim.lsp.buf_get_clients()) do
      local client_diags = vim.lsp.diagnostic.get_all(client.id)

      for bufnr, diags in pairs(client_diags) do
        if all_diags[bufnr] == nil then
          all_diags[bufnr] = diags
        else
          for diag in diags do
            all_diags[bufnr][#all_diags[bufnr]+1] = diag
          end
        end
      end

    end
  else
    all_diags = vim.lsp.diagnostic.get_all()
  end

  -- priority items for current buffer file
  local pqfitems = {}
  local pwarnings = {}

  for bufnr, diagnostics in pairs(all_diags) do
    local uri = vim.uri_from_bufnr(bufnr)

    for _, d in ipairs(diagnostics) do
      local item = {
        bufrn = bufnr,
        filename = vim.uri_to_fname(uri),
        text = d.message,
        lnum = d.range.start.line + 1,
        col = d.range.start.character + 1,
      }

      if d.severity == 1 then
        item.type = 'E'

        if item.filename == priority_filename then
          pqfitems[#pqfitems + 1] = item
        else
          qfitems[#qfitems + 1] = item
        end
      elseif d.severity == 2 then
        item.type = 'W'

        if item.filename == priority_filename then
          pwarnings[#pwarnings + 1] = item
        else
          warnings[#warnings + 1] = item
        end
      end
    end
  end

  for i = 1, #qfitems do
    pqfitems[#pqfitems + 1] = qfitems[i]
  end

  for i = 1, #pwarnings do
    pqfitems[#pqfitems + 1] = pwarnings[i]
  end

  for i = 1, #warnings do
    pqfitems[#pqfitems + 1] = warnings[i]
  end

  return pqfitems
end


M.foreign_qf = false

local function populate_qflist(open_qflist)
  -- check if quickfix is focused
  -- on unfocus WinEnter/BufEnter au should be triggered
  -- so we can just return here
  --
  -- also, if quickfix is focused but open_qflist is true
  -- we assume that user wants to manually refresh diag so we proceed
  if not open_qflist and vim.api.nvim_buf_get_option(0, 'buftype') == 'quickfix' then
    if M.debug then
      print('quickfix is focused, not updating')
    end
    return
  end

  local priority_filename = vim.fn.expand('%:p')

  local all_diagnostics = get_all_diagnostics_as_qfitems(priority_filename)
  if lsp.buf.server_ready() then
    setqflist(all_diagnostics)
    if open_qflist then
      if M.debug then
        print('setting foreign to false')
      end
      if #all_diagnostics == 0 and not M.foreign_qf then
        api.nvim_command('cclose')
      else
        api.nvim_command('copen')
      end
      M.foreign_qf = false
    end
  end
end

local function update_all_diagnostics(opts)
  local open_qflist = opts ~= nil and opts['open_qflist']

  if open_qflist then
    populate_qflist(open_qflist)
  else
    M.debounced_populate_qflist(open_qflist)
  end
end

M.open_all_diagnostics = function()
  update_all_diagnostics({ open_qflist = true})
end

M.diagnostics_hook = function()
  if not M.foreign_qf then
    update_all_diagnostics()
  elseif M.debug then
    print('foreign quickfix, not populating')
  end
end

function M.init()
  M.debounced_populate_qflist = debounce_trailing(M.debounce_ms, populate_qflist)
end

return M
