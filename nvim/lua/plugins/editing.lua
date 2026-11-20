return {
  {
    'kylechui/nvim-surround',
    opts = {},
  },
  {
    'windwp/nvim-autopairs',
    cond = not vim.g.vscode,
    opts = {},
  },
  {
    'chrisgrieser/nvim-spider',
    keys = {
      { "W", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" } },
      { "E", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" } },
      { "B", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" } },
      { "gE", "<cmd>lua require('spider').motion('ge')<CR>", mode = { "n", "o", "x" } },
    },
  },
}
