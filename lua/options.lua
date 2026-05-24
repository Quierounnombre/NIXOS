local o = vim.o

-- GENERAL

o.encoding       = "utf-8"
o.number         = true
o.relativenumber = true
o.signcolumn     = "yes"
o.ruler          = true
o.undolevels     = 1000
o.showmatch      = true
o.wrap           = false
o.virtualedit    = "all"
o.title          = true
o.background     = "dark"
o.wildmenu       = true
o.clipboard      = "unnamedplus"
o.cursorline     = true
o.laststatus     = 2
o.termguicolors  = true

-- SEARCH

o.hlsearch   = true
o.smartcase  = true
o.ignorecase = true
o.incsearch  = true

-- TABS

o.expandtab   = false
o.autoindent  = true
o.smarttab    = true
o.smartindent = true
o.shiftwidth  = 4
o.tabstop     = 4
o.softtabstop = 0

-- LISTCHARS

o.list = true
vim.opt.listchars = { tab = "| ", trail = "·", eol = "$" }
