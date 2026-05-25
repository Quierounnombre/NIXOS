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

	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, {})
end

local = 5

local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config("gopls", { on_attach = on_attach, capabilities = capabilities, cmd = { "gopls" } })
vim.lsp.config("clangd", { on_attach = on_attach, capabilities = capabilities, cmd = { "clangd" } })
vim.lsp.config("lua_ls", {
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "lua-language-server" },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = { enable = false },
		},
	},
})
vim.lsp.config("nixd", { on_attach = on_attach, capabilities = capabilities, cmd = { "nixd"} })
vim.lsp.enable({ "gopls", "clangd", "lua_ls", "nixd" })

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
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete {},
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},
}
