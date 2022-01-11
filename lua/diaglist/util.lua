local M = {}


M.type_to_num = function(t)
  if t == 'E' then
    return 1
  end

  if t == 'W' then
    return 2
  end

  if t == 'I' then
    return 3
  end

  return 4
end

M.get_qflist = function(opts)
  local all_diags = vim.diagnostic.get(opts.bufnr)
  local qflist = vim.diagnostic.toqflist(all_diags)

  table.sort(qflist, function(a,b)
    local atypen = M.type_to_num(a.type)
    local btypen = M.type_to_num(b.type)

    if atypen < btypen then
      return true
    end

    if atypen == btypen then
      local aok, auri = pcall(vim.uri_from_bufnr(a.bufnr))
      local bok, buri = pcall(vim.uri_from_bufnr(b.bufnr))

      if aok and bok and auri == buri then
        return a.lnum < b.lnum
      end

      if aok and opts.priority_uri then
        return auri == opts.priority_uri
      end
    end

    return false
  end)

  return qflist
end


return M
