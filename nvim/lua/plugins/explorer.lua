return {
    {
		'nvim-tree/nvim-web-devicons',
        lazy = true,
        opts = {},
    },
	{
		'nvim-tree/nvim-tree.lua',
		cond = not vim.g.vscode,
		keys = {
			{ '<leader>t', '<cmd>NvimTreeToggle<cr>', desc = 'Toggle file tree' },
		},
		init = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
		config = function()
			require('nvim-tree').setup({
				view = { width = 40 },
			})
		end,
	},
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional, for icons
        lazy = false,
        opts = {
            default_file_explorer = true, -- replaces netrw, so `nvim .` opens oil
        },
        keys = {
            { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
        },
    }
}
