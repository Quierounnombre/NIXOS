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
				on_attach = function(bufnr)
					local api = require("nvim-tree.api")
					api.config.mappings.default_on_attach(bufnr)
					vim.keymap.set("n", "t", api.node.open.tab, { buffer = bufnr, nowait = true })
					vim.keymap.set("n", "<C-e>", api.tree.close, { buffer = bufnr, nowait = true })
					vim.keymap.set("n", "l", api.tree.change_root_to_node, { buffer = bufnr, nowait = true })
					vim.keymap.set("n", "h", api.tree.change_root_to_parent, { buffer = bufnr, nowait = true })
				end
			})
		end,
	},
	{ "echasnovski/mini.cursorword", version = "*", config = true },
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
			'rafamadriz/friendly-snippets',
			'hrsh7th/cmp-nvim-lsp'
        },
    },
})

local on_attach = function(_, bufnr)

	local bufmap = function(keys, func)
		vim.keymap.set('n', keys, func, { buffer = bufnr })
	end

	bufmap('<leader>r', vim.lsp.buf.rename)
	bufmap('<leader>a', vim.lsp.buf.code_action)
	bufmap('gd', vim.lsp.buf.definition)
	bufmap('gD', vim.lsp.buf.declaration)
	bufmap('gI', vim.lsp.buf.implementation)
	bufmap('<leader>D', vim.lsp.buf.type_definition)
	bufmap('K', vim.lsp.buf.hover)
	bufmap('[d', vim.diagnostic.goto_prev)
	bufmap(']d', vim.diagnostic.goto_next)
	bufmap('<leader>e', vim.diagnostic.open_float)
	bufmap('gr', vim.lsp.buf.references)


	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, {})
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config("nixd", { on_attach = on_attach, capabilities = capabilities, cmd = { "nixd"} })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	callback = function()
		vim.lsp.start({
			name = "gopls",
			cmd = { "gopls" },
			on_attach = on_attach,
			capabilities = capabilities,
			root_dir = vim.fs.dirname(vim.fs.find({"go.mod", ".git"}, { upward = true })[1])
		})
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp" },
	callback = function()
		vim.lsp.start({
			name = "clangd",
			cmd = { "clangd" },
			root_dir = vim.fs.dirname(vim.fs.find({"compile_commands.json", ".git"}, { upward = true })[1]),
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.lsp.start({
			name = "lua_ls",
			cmd = { "lua-language-server" },
			root_dir = vim.fs.dirname(vim.fs.find({".luarc.json", ".git"}, { upward = true })[1]),
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "nix",
	callback = function()
		vim.lsp.start({
			name = "nixd",
			cmd = { "nixd" },
			root_dir = vim.fs.dirname(vim.fs.find({"flake.nix", ".git"}, { upward = true })[1]),
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "dockerfile",
	callback = function()
		vim.lsp.start({
			name = "dockerls",
			cmd = { "docker-langserver", "--stdio" },
			root_dir = vim.fs.dirname(vim.fs.find({"Dockerfile", ".git"}, { upward = true })[1]),
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end,
})

local cmp = require('cmp')
local luasnip = require('luasnip')

require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert {
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-b>'] = cmp.mapping.select_prev_item(),
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete {},
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},
}
