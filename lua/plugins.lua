local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"tomasiser/vim-code-dark",
		lazy     = false,
		priority = 1000,
		config   = function() vim.cmd("colorscheme codedark") end,
	},
	{ "tpope/vim-fugitive" },
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			vim.g.loaded_netrw       = 1
			vim.g.loaded_netrwPlugin = 1
			require("nvim-tree").setup({
				hijack_netrw        = true,
				view                = { width = 30 },
				sync_root_with_cwd  = true,
				update_focused_file = { enable = true },
			})
		end,
	},
	{ "echasnovski/mini.cursorword", version = "*", config = true },
	{ "nvim-lua/plenary.nvim", lazy = true },
})
