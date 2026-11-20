return {
  {
    'lewis6991/gitsigns.nvim',
    cond = not vim.g.vscode,
    opts = {},
  },
  {
    'akinsho/git-conflict.nvim',
    cond = not vim.g.vscode,
    event = 'VeryLazy',
    opts = {},
  },
}
