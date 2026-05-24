local map = vim.keymap.set

map("i", "jk", "<Esc>")
map({ "i", "n" }, "<C-s>", "<Esc>:update<CR>")

map("n", "<C-e>", function()
	local view = require("nvim-tree.view")
	if view.is_visible() then
		require("nvim-tree.api").tree.close()
	else
		require("nvim-tree.api").tree.toggle()
	end
end)

local term_bufnr = -1
 
local function toggle_terminal()
	if term_bufnr ~= -1 and vim.fn.bufexists(term_bufnr) == 1 then
		local win = vim.fn.bufwinnr(term_bufnr)
		if win ~= -1 then
			vim.cmd(win .. "wincmd c")
			return
		end
	end
	vim.cmd("botright split | resize 30")
	if term_bufnr == -1 or vim.fn.bufexists(term_bufnr) == 0 then
		vim.cmd("terminal")
		term_bufnr = vim.api.nvim_get_current_buf()
	else
		vim.cmd("buffer " .. term_bufnr)
	end
	vim.cmd("startinsert")
end

map("n", "<char-241>", toggle_terminal)
map("t", "<char-241>", function() vim.cmd("stopinsert"); toggle_terminal() end)
map("t", "<Esc>",      function() vim.cmd("stopinsert"); toggle_terminal() end)


