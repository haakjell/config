return {
  {
    'iamcco/markdown-preview.nvim',
    cond = not vim.g.vscode,
    ft = { 'markdown' },
    cmd = { 'MarkdownPreview', 'MarkdownPreviewStop', 'MarkdownPreviewToggle' },
    event = 'VeryLazy',
    build = function()
      require('lazy').load({ plugins = { 'markdown-preview.nvim' } })
      vim.fn['mkdp#util#install']()
    end,
  },
  {
    'yousefhadder/markdown-plus.nvim',
    cond = not vim.g.vscode,
    ft = 'markdown',
    event = 'VeryLazy',
    opts = {},
    config = function()
      require('markdown-plus').setup(opts)
      vim.api.nvim_set_hl(0, '@markup.raw.markdown_inline', {
        fg = '#7aa2f7',
        italic = true,
      })
    end
  },
}
