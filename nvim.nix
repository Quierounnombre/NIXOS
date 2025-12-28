{ config, pkgs, ... }:

{
	system.activationScripts.create_vimrc =
	{
		text = ''
mkdir -p /home/vicente/.config/nvim
cat <<'EOF' > /home/vicente/.config/nvim/init.vim
"---GENERAL---"
set number
set ruler
set undolevels=1000
set backspace=indent,eol,start
set virtualedit=all
set showmatch
set encoding=utf-8
set relativenumber
set nowrap
syntax enable
"---SEARCH---"
set hlsearch
set smartcase
set ignorecase
set incsearch
"---TABS---"
set noexpandtab
set autoindent
set smarttab
set softtabstop=0
set smartindent
set shiftwidth=4
set tabstop=4
"---UI---"
set title
set background=dark
set wildmenu
source /home/vicente/.config/nvim/plugins.vim
"---COLOR DARK+---"
set termguicolors
colorscheme codedark
set background=dark
"---UI(CURSOR BUG)---"
set cursorline
hi CursorLine gui=underline cterm=underline guibg=NONE ctermbg=NONE
"---STATUSLINE---"
set laststatus=2
set statusline	=
hi User1 guifg=#ff4444	guibg=NONE
hi User2 guifg=#00ffff guibg=NONE
set statusline=%2*%f\ %h%m%r%=%y\ L:%l:%c:C\ %p%%\ %1*%{FugitiveStatusline()}%*
"---NERDTREE---"
let g:NERDTreeHijackNetrw = 1
let NERDTreeShowActiveFile = 1
let g:NERDTreeTabsOpenOnNewTab = 0
let g:NERDTreeTabsShareSameTree = 1
nnoremap <C-e> :NERDTreeToggle<CR>
let NERDTreeWinSize = 30
let NERDTreeShowIcons = 1
let g:NERDTreeChDirMode=2
autocmd DirChanged * NERDTreeRefreshRoot
autocmd BufWritePost * NERDTreeRefreshRoot
"---CUSTOM HOTKEYS---"
inoremap jk <Esc>
inoremap <C-s> <Esc>:update<CR>
nnoremap <C-s> :update<CR>
"---TAB_GRAPHICS---"
set list
set listchars=tab:\|\ ,trail:·,eol:$
"---TERMINAL_TOGGLE---"
nnoremap <Char-241> :call ToggleTerminal()<CR>
tnoremap <Char-241> <C-\><C-n>:call ToggleTerminal()<CR>
tnoremap <Esc> <C-\><C-n>:call ToggleTerminal()<CR>
let g:terminal_bufnr = -1
function! ToggleTerminal()
	if bufexists(g:terminal_bufnr) && bufwinnr(g:terminal_bufnr) != -1
		let l:curwin = winnr()
		execute bufwinnr(g:terminal_bufnr) . "wincmd c"
		for w in range(1, winnr('$'))
			execute w . "wincmd w"
			if getbufvar(winbufnr(w), '&filetype') !=# 'nerdtree'
				break
			endif
		endfor
	else
		if g:terminal_bufnr == -1 || !bufexists(g:terminal_bufnr)
			botright split
			resize 30
			terminal
			let g:terminal_bufnr = bufnr('%')
		else
			botright split
			resize 30
			execute "buffer " . g:terminal_bufnr
		endif
		startinsert
	endif
endfunction
"---CLIPBOARD--"
set clipboard+=unnamedplus
"---CURSOR_HIGHLIGHT---"
hi default CursorWord cterm=none gui=none ctermfg=Yellow guifg=#FFFF00
EOF
chmod 0644 /home/vicente/.config/nvim/init.vim
		'';
	};

	system.activationScripts.create_vimplugins =
	{
		text = ''
		cat <<'EOF' > /home/vicente/.config/nvim/plugins.vim
let s:plugin_dir = expand('~/.vim/plugged')

function! s:ensure(repo)
let name = split(a:repo, '/')[-1]
let path = s:plugin_dir . '/' . name

if !isdirectory(path)
	if !isdirectory(s:plugin_dir)
		call mkdir -p (s:plugin_dir, 'p')
	endif
	execute '!${pkgs.git}/bin/git clone --depth=1 https://github.com/' . a:repo . ' ' . shellescape(path)
endif

execute 'set runtimepath+=' . fnameescape(path)
endfunction

"INSTALL THE PLUGGINS"
call s:ensure('tomasiser/vim-code-dark')
call s:ensure('tpope/vim-fugitive')
call s:ensure('preservim/nerdtree')
call s:ensure('itchyny/vim-cursorword')
call s:ensure('uhs-robert/sshfs.nvim')
call s:ensure('nvim-lua/plenary.nvim')

"UPDATE THE MANUALS"
helptags ALL
EOF
		chmod 0644 /home/vicente/.config/nvim/plugins.vim
		'';
	};

	# Create a service since i need ssh to be online
	systemd.services.install-vim-plugins =
	{
		description = "Install Vim plugins after SSH is ready";
		wantedBy = [ "default.target" ];
		after = [ "network-online.target" "sshd.service" ];
		wants = [ "network-online.target" "sshd.service" ];
		serviceConfig =
		{
			Type = "oneshot";
			User = "vicente";
			ExecStart = "${pkgs.neovim}/bin/nvim -es -u NONE -c 'source /home/vicente/.config/nvim/plugins.vim' -c qall";
		};
	};

	system.activationScripts.create_vim_lua =
	{
		text = ''
mkdir -p /home/vicente/.config/nvim
cat <<'EOF' > /home/vicente/.config/nvim/init.lua
vim.o.encoding = "utf-8"
vim.cmd('source /home/vicente/.config/nvim/init.vim')
require("sshfs").setup({

})
EOF
chmod 0644 /home/vicente/.config/nvim/init.lua
		'';
	};
}
