local api = vim.api
local lsp = require("vim.lsp")

local Q = {
  debug = false,
}

-- original function is copied from nvim-metals
-- https://github.com/scalameta/nvim-metals/blob/69a5cf9380defde5be675bd5450e087d59314855/lua/metals/diagnostic.lua
--
-- added current buf problems prioritization
local function get_all_lsp_diagnostics_as_qfitems()
  local qfitems = {}
  -- Temporary array for warnings, so they are appended after errors
  local warnings = {}

  local all_diags = lsp.diagnostic.get_all()

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
        item.type = "E"

        if item.filename == vim.fn.expand("%:p") then
          pqfitems[#pqfitems + 1] = item
        else
          qfitems[#qfitems + 1] = item
        end
      elseif d.severity == 2 then
        item.type = "W"

        if item.filename == vim.fn.expand("%:p") then
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

Q.foreign_qf = true

local function update_all_diagnostics(opts)
  local open_qflist = opts ~= nil and opts['open_qflist']

  local all_diagnostics = get_all_lsp_diagnostics_as_qfitems()
  if #all_diagnostics > 0 then
    lsp.util.set_qflist(all_diagnostics)
    if open_qflist then
      if Q.debug then
        print("setting foreign to false")
      end
      Q.foreign_qf = false
      api.nvim_command("copen")
    end
    -- api.nvim_command("wincmd p")
  else
    api.nvim_command("cclose")
  end
end

--  Fills the quick-fix with all the current LSP workspace diagnostics and
--  opens it.
Q.open_all_diagnostics = function()
  update_all_diagnostics({ open_qflist = true})
end

Q.lsp_diagnostics_hook = function()
  if not Q.foreign_qf then
    update_all_diagnostics()
  elseif Q.debug then
    print("foreign quickfix, not populating")
  end
end

return Q
