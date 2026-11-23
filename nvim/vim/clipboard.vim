" Clipboard

" Use system clipboard
set clipboard=unnamedplus

" WSL: force win32yank, which converts CRLF to LF on paste.
" Without this, Neovim picks wl-copy (via WSLg) first, which keeps the ^M.
if has('wsl')
	let g:clipboard = 'win32yank'
endif
