-- https://github.com/scalameta/nvim-metals/blob/69a5cf9380defde5be675bd5450e087d59314855/lua/metals/diagnostic.lua
local api = vim.api
local lsp = require("vim.lsp")

local M = {}

-- Collects all LSP buffer diagnostic lists and flattens them into a quick-fix item list
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

M.foreign_qf = true

local function update_all_diagnostics(opts)
  local open_qflist = opts ~= nil and opts['open_qflist']

  local all_diagnostics = get_all_lsp_diagnostics_as_qfitems()
  if #all_diagnostics > 0 then
    lsp.util.set_qflist(all_diagnostics)
    if open_qflist then
      Foreign_qf = false
      api.nvim_command("copen")
    end
    -- api.nvim_command("wincmd p")
  else
    api.nvim_command("cclose")
  end
end

--  Fills the quick-fix with all the current LSP workspace diagnostics and
--  opens it.
M.open_all_diagnostics = function()
  M.foreign_qf = false
  update_all_diagnostics({ open_qflist = true})
end

M.lsp_diagnostics_hook = function()
  if not M.foreign_qf then
    update_all_diagnostics()
  end
end


M.quick_fix_hook = function()
  M.foreign_qf = true
end


function M.init()
    -- " autocmd! User LspDiagnosticsChanged lua require('lsp-vimway-diag').lsp_diagnostics_hook()
  vim.api.nvim_command [[aug lsp_diagnostics]]
  vim.api.nvim_command [[au!]]
  vim.api.nvim_command [[au User LspDiagnosticsChanged lua require("lsp-vimway-diag").lsp_diagnostics_hook()]]
  vim.api.nvim_command [[aug END]]

  vim.api.nvim_command [[aug qf_hook]]
  vim.api.nvim_command [[au!]]
  vim.api.nvim_command [[au! QuickFixCmdPre * lua require("lsp-vimway-diag").quick_fix_hook()]]
  vim.api.nvim_command [[aug END]]
end

return M
