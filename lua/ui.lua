vim.api.nvim_set_hl(0, "CursorLine", { underline = true, bg = "NONE" })
vim.api.nvim_set_hl(0, "User1",      { fg = "#ff4444", bg = "NONE" })
vim.api.nvim_set_hl(0, "User2",      { fg = "#00ffff", bg = "NONE" })
vim.api.nvim_set_hl(0, "MiniCursorword", { fg = "#FFFF00", bold = true })
 
vim.o.statusline = "%2*%f %h%m%r%=%y L:%l:%c:C %p%% %1*%{FugitiveStatusline()}%*"
 
local au = vim.api.nvim_create_autocmd
au("DirChanged",   { callback = function() require("nvim-tree.api").tree.reload() end })
au("BufWritePost", { callback = function() require("nvim-tree.api").tree.reload() end })
