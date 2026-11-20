augroup filetype_settings
    autocmd!
    autocmd FileType markdown setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType lua setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" Enable spell check in markdown files
autocmd FileType markdown setlocal spell spelllang=nb,en_gb,en_us

