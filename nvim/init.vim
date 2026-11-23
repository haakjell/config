" Håkjell's nvim config

" Set runtime path so config files auto-resolve relative paths
lua vim.opt.runtimepath:prepend(vim.fn.expand('~/git/config/nvim'))

" Vimscript config
"
" General UI settings
source <sfile>:h/vim/settings.vim
" Key bindings
source <sfile>:h/vim/keymaps.vim
" Special autocommands
source <sfile>:h/vim/autocmds.vim
" Commands
source <sfile>:h/vim/commands.vim
" Clipboard
source <sfile>:h/vim/clipboard.vim

" Lua config
"
" Enable lua module caching
lua vim.loader.enable()
" Disable unused providers (each costs a PATH search + process spawn)
let g:loaded_python3_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_node_provider = 0
" Load general UI settings
lua require('config.settings')
" Bootstrap lazy.nvim and load plugins
lua require('config.lazy')

