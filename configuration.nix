# Edit this configuration file to define what should be installed on your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
	imports =
	[ # Include the results of the hardware scan.
	./hardware-configuration.nix
	./nvim.nix
	];

	# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.kernelPackages = pkgs.linuxPackages_latest;
	boot.kernelParams = [ "quiet" "loglevel=3" ];
	boot.blacklistedKernelModules = [ "kvm" "kvm_intel" ]; # NEEDED for vbox nested virt
	boot.initrd.checkJournalingFS = false; # Disable initrd checking due to busy box failure.

	# Network
	networking.networkmanager.enable = true;
	networking.hostName = "vicxos";
	networking.firewall.enable = true;

	#Flakes
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
	services.xserver =
	{
		enable = true;
		displayManager.lightdm.enable = true;
		desktopManager.cinnamon.enable = true;
		videoDrivers = [];
		autoRepeatDelay = 200;
		autoRepeatInterval = 50;
		xkb = 
		{
			layout = "es";
		};
	};
	security.polkit.enable = true;
	services.gnome.gnome-keyring.enable = true;
	xdg.portal = {
		enable = true;
		extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
		config.common.default = "gtk";
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
		extraGroups = [
			"networkmanager"
			"wheel"
			"docker"
			"vboxusers"
			"kvm"
			"wireshark"
		];
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
					"vi-mode"
				];
			};
		};
		neovim = 
		{
			enable = true;
			defaultEditor = true;
		};
		firefox = 
		{
			enable = true;
		};
		wireshark = 
		{
			enable = true;
		};
	};

	# Pkgs
	environment.systemPackages = with pkgs;
	[
		man-pages									# Man
		gcc											# C-Utils
		valgrind									# C-Utils
		linuxHeaders								# C-Utils
		cmake										# C-Utils
		gnumake										# C-Utils
		zlib										# C-Utils
		openssl										# C-Utils
		git											# Git
		brave										# Browser
		pciutils									# Utils
		usbutils									# Utils
		parted										# Utils
		unzip										# Utils
		pkg-config									# Utils
		libGLU										# Utils
		libGL										# Utils
		file										# Utils
		tree										# Utils
		jq											# Utils
		vegeta										# Testing
		nasm										# Asembly
		go											# Go
		python3										# Python
		wget										# Networking
		iw											# Networking
		traceroute									# Networking
		curl										# Networking
		inetutils									# Networking
		tcpdump										# Networking
		postman										# Networking
		sshfs										# Networking
		wireshark									# Networking
		gtk4										# Graphics
		xclip										# Linux
		nixos-install-tools							# Raspb Nixos
		rpi-imager									# Raspb imager
		glances										# Resource Manager
		slack										# Office
		cockatrice									# Gaming
		openra										# Gaming
		libreoffice									# Productivity
		typescript									# Typscript
		nerd-fonts.fira-code						# NerdFonts
		godotPackages_4_6.godot-mono				# Godot with c#
		telegram-desktop							# Telegram
		wine										# WINE
		lua-language-server							# LSP
		gopls										# LSP
		dockerfile-language-server					# LSP
		nixd										# LSP
		clang-tools									# LSP
		theharvester								# OSINT
		dig											# OSINT
		steghide									# OSINT
		fcrackzip									# OSINT
		tor-browser									# OSINT
		lunar-client								# MC
		ollama										# LLM
	];

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
			daemon.settings =
			{
				dns =
				[
					"8.8.8.8"
					"1.1.1.1"
				];
				registry-mirrors = ["https://mirror.gcr.io"];
			};
		};
		virtualbox =
		{
			host.enable = true;
			host.enableExtensionPack = true;
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

	#STEAM

	programs.steam.enable = true;
	hardware.graphics.enable32Bit = true;


	# Fix graphics emulator
	hardware.graphics = {
		enable = true;
	};

	# Fix Intel or AMD infos on boot
	hardware.cpu.intel.updateMicrocode = true;

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# Clean up
	nix.gc.automatic = true;
	nix.gc.dates = "weekly";
	nix.gc.options = "--delete-older-than 30d";

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion	= "25.05"; # Did you read the comment?

}
