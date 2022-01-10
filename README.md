# Live-updating Neovim LSP diagnostics in quickfix and loclist

![demo](https://github.com/onsails/diaglist.nvim/raw/gif/demo.gif)

## Features

- [x] workspace diagnostics of all buffers in quickfix
    - [x] prioritize current buf diagnostics
    - [x] live diagnostics update
    - [x] no conflicts with other commands using quickfix
    - [x] optionally show only current buffer's clients diagnostics
    - [x] debounce
- [x] current buffer diagnostics in loclist
    - [x] live diagnostics update
    - [ ] no conflicts with other commands using loclist
    - [ ] debounce

## Setup

```lua
lua require("diaglist").init({
    -- optional settings
    -- below are defaults
    debug = false, 

    -- increase for noisy servers
    debounce_ms = 150,
})
```

Init sets diag update on `LspDiagnosticsChanged`, `WinEnter`, `BufEnter` for live diagnostics update
and `QuickFixCmdPre` to avoid conflicts with other commands using quickfix.

## Mappings

There are no default mappings. Here is an example:

```vimscript
nmap <space>dw <cmd>lua require('diaglist').open_all_diagnostics()<cr>
nmap <space>d0 <cmd>lua require('diaglist').open_buffer_diagnostics()<cr>
```
