return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    cond = not vim.g.vscode,
    config = function()
      vim.cmd.colorscheme('tokyonight-night')
    end,
  }
}
