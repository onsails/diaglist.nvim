# Vim-way lsp diagnostics for Neovim

## Features

- [x] workspace diagnostics of all buffers in quickfix
    - [x] prioritize current buf diagnostics
    - [x] live diagnostics update
    - [x] no conflicts with other commands using quickfix
- [x] current buffer diagnostics in loclist
    - [x] live diagnostics update
    - [ ] no conflicts with other commands using loclist

## Setup

```vimscript
lua require("vimway-lsp-diag").init()
```

Init sets diag update on `LspDiagnosticsChanged`, `WinEnter` for live diagnostics update
and `QuickFixCmdPre` to avoid conflicts with other commands using quickfix.

## Mappings

There are no default mappings. Here is an example:

```vimscript
nmap <space>dw <cmd>lua require('vimway-lsp-diag').open_all_diagnostics()<cr>
nmap <space>d0 <cmd>lua require('vimway-lsp-diag').open_buffer_diagnostics()<cr>
```
