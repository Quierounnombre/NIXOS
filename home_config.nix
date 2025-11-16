# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
	imports =
	[ # Include the results of the hardware scan.
	./hardware-configuration.nix
	];

	# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.kernelModules = [ "mt7921e" ];
	boot.kernelPackages = pkgs.linuxPackages_latest;
	boot.kernelParams = [ "quiet" "loglevel=3" ];	
	boot.blacklistedKernelModules = [ "kvm" "kvm_intel" ]; #NEEDED for virtualbox

	# Network
	networking.networkmanager.enable = true;
	networking.hostName = "vicxos";
	networking.firewall.enable = true;

	# Localization
	time.timeZone = "Europe/Madrid";
	i18n.defaultLocale = "es_ES.UTF-8";
	i18n.extraLocaleSettings = 
	{
		LC_ADDRESS = "es_ES.UTF-8";
		LC_IDENTIFICATION = "es_ES.UTF-8";
		LC_MEASUREMENT = "es_ES.UTF-8";
		LC_MONETARY = "es_ES.UTF-8";
		LC_NAME = "es_ES.UTF-8";
		LC_NUMERIC = "es_ES.UTF-8";
		LC_PAPER = "es_ES.UTF-8";
		LC_TELEPHONE = "es_ES.UTF-8";
		LC_TIME = "es_ES.UTF-8";
	};
	console.keyMap = "es";

	# Graphics
	services.xserver.enable = true;
	services.xserver.displayManager.lightdm.enable = true;
	services.xserver.desktopManager.cinnamon.enable = true;
	services.xserver.xkb =
	{
		layout = "es";
	};

	# Printing
	services.printing.enable = true;

	# Sound
	services.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire =
	{
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};

	# Me
	users.users.vicente =
	{
		isNormalUser = true;
		description = "Vicente";
		extraGroups = [ "networkmanager" "wheel" "docker" "vboxusers" ];
		packages = with pkgs;
		[
		];
		shell = pkgs.zsh;
	};

	# Set up some programs
	programs =
	{
		zsh = 
		{
			enable = true;
			ohMyZsh = 
			{
				enable = true;
				theme = "robbyrussell";
				plugins = 
				[
				"sudo"
				"terraform"
				"systemadmin"
				"vi-mode"
				];
			};
		};
		git = 
		{
			enable = true;
		};
		vim = 
		{
			enable = true;
			defaultEditor = true;
		};
		firefox = 
		{
			enable = true;
		};
	};

	# Pkgs
	environment.systemPackages = with pkgs;
	[
		vim							# Editor
		zsh							# Shell
		man-pages					# Man
		gcc							# C-Utils
		valgrind					# C-Utils
		gnumake						# C-Utils
		linuxHeaders				# C-Utils
		cmake						# C-Utils
		git							# Git
		brave						# Browser
		pciutils					# Utils
		usbutils					# Utils
		nasm						# Asembly
		docker						# Virtualisation
		vagrant						# Virtualisation
		virtualbox					# Virtualisation
		k3s							# Virtualisation
		go							# Go
		wget						# Networking
		iw							# Networking
		traceroute					# Networking
		wireshark					# Networking
		networkmanager				# Networking
		curl						# Networking
		gtk4						# Graphics
		linux-firmware				# Linux
		linux						# Linux
		cloudflare-warp				# Networking + privacy
		slack						# Office
	];

	# Create vimrc file
	system.activationScripts.create_vimrc =
	{
		text = ''
cat <<'EOF' > /home/vicente/.vimrc
echo "I use vim"
echo "(•_•)"
echo "( •_•)>⌐■-■"
echo "(⌐■_■)"
"---GENERAL---"
set number
set ruler
set undolevels=1000
set backspace=indent,eol,start
set virtualedit=all
set showmatch
set encoding=utf-8
set relativenumber
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
source ~/.vim/plugins.vim
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
EOF
chmod 0644 /home/vicente/.vimrc
		'';
	};

	# Create vim plugins
	system.activationScripts.create_vimplugins =
	{
		text = ''
		cat <<'EOF' > /home/vicente/.vim/plugins.vim
let s:plugin_dir = expand('~/.vim/plugged')

function! s:ensure(repo)
let name = split(a:repo, '/')[-1]
let path = s:plugin_dir . '/' . name

if !isdirectory(path)
	if !isdirectory(s:plugin_dir)
		call mkdir(s:plugin_dir, 'p')
	endif
	execute '!${pkgs.git}/bin/git clone --depth=1 https://github.com/' . a:repo . ' ' . shellescape(path)
endif

execute 'set runtimepath+=' . fnameescape(path)
endfunction

"INSTALL THE PLUGGINS"
call s:ensure('tomasiser/vim-code-dark')
call s:ensure('tpope/vim-fugitive')
call s:ensure('preservim/nerdtree')

"UPDATE THE MANUALS"
helptags ALL
EOF
		chmod 0644 /home/vicente/.vim/plugins.vim
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
			ExecStart = "sh -c '
			echo rm -rf /home/vicente/.vim/plugged
			echo ${pkgs.vim}/bin/vim -es -u NONE -c 'source /home/vicente/.vim/plugins.vim' -c qall
			'
			";
		};
	};


	# Enviroment vars
	environment.variables =
	{
		GTK_THEME = "Adwaita:dark"; #Dark theme
	};

	# Virtualisation configs
	virtualisation =
	{
		docker =
		{
			enable = true;
		};
		virtualbox =
		{
			host.enable = true;
		};
	};

	#Enable cloudflare-warp?
	systemd.services.cloudflare-warp =
	{
		wantedBy = [ "multi-user.target" ];
		serviceConfig =
		{
			ExecStart = "${pkgs.cloudflare-warp}/bin/warp-svc";
		};
	};

	systemd.services.init-warp =
	{
		description = "Initialize Cloudflare WARP non-interactively";
		wantedBy = [ "multi-user.target" ];
		after = [ "cloudflare-warp.service" ];
		serviceConfig =
		{
			Type = "oneshot";	
			RemainAfterExit = true;
			ExecStart = pkgs.writeShellScript "init-warp.sh" ''
			set -e
			${pkgs.cloudflare-warp}/bin/warp-cli --accept-tos registration delete
			${pkgs.cloudflare-warp}/bin/warp-cli --accept-tos registration new
			${pkgs.cloudflare-warp}/bin/warp-cli --accept-tos connect
			'';
		};
	};

	# Enviroment 
	environment.etc =
	{
		"gitconfig".text =
		''
		[user]
		name  = Quierounombre
		email = vicengandrade@gmail.com

		[alias]
		lol   = log --decorate --pretty --graph --stat
		l     = log --decorate --pretty --oneline
		s     = status -s --ahead-behind
		sb    = status -s --ahead-behind -b
		ac    = add *.c *.cpp *.h Makefile
		aa    = add *
		c     = commit -m
		po    = push origin
		pom   = push origin master
		pov   = push origin Vicente
		pp    = push personal
		ppm   = push personal master
		p     = push
		r     = remote
		b     = branch
		ra    = remote add
		rp    = remote add personal
		ro    = remote add origin
		ch    = checkout
		cho   = checkout master
		chv   = checkout Vicente
		suba  = submodule add
		subp  = submodule update --merge --remote
		subc  = submodule update --init --recursive

		[status]
		submodulesummary = true
		'';
		"gitconfig".mode = "0644";
	};

	# Firmware attemp
	hardware.enableRedistributableFirmware = true;
	hardware.enableAllFirmware = true;


	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion	= "25.05"; # Did you read the comment?

}
