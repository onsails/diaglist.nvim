local M = {}

-- adopted from https://github.com/lewis6991/gitsigns.nvim/blob/main/lua/gitsigns/debounce.lua
-- added vim.schedule_wrap
function M.debounce_trailing(ms, fn)
 local timer = vim.loop.new_timer()
 return function(...)
    local argv = { ... }
    timer:start(ms, 0, function()
       timer:stop()
       vim.schedule_wrap(function()
         fn(unpack(argv))
       end)()
    end)
 end
end

return M
