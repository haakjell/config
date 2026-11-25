return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- main does not support lazy-loading
    cond = not vim.g.vscode,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({ "lua", "markdown", "markdown_inline", "vim", "vimdoc", "c_sharp" })

      -- main doesn't turn on highlighting for you
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
}
