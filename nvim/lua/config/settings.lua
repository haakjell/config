-- Settings

-- Enable highlighted yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.hl.on_yank() end,
})

-- Reopen file to same location as last time
vim.api.nvim_create_autocmd('BufWinEnter', {
    group = vim.api.nvim_create_augroup('last_place', { clear = true }),
    callback = function(args)
        if vim.bo[args.buf].filetype == 'gitcommit' then return end

        local line = vim.api.nvim_buf_get_mark(args.buf, '"')[1]
        if line > 0 and line <= vim.api.nvim_buf_line_count(args.buf) then
            vim.cmd('normal! g`"zz')
        end
    end,
})

-- Disable text wrap in md files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.wrap = false
    end
})

-- Keep buffer of eight lines between cursor and end of screen
vim.opt.scrolloff = 8

