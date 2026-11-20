-- Lazy.nvim setup

-- Bootstrap lazy.nvim and load all plugins from lua/plugins/
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Add plugins
require('lazy').setup('plugins', {
  performance = {
    rtp = {
      paths = { vim.fn.expand('~/git/config/nvim') }
    }
  }
})

