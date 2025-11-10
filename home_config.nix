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

  # Network
  networking.networkmanager.enable = true;
  networking.hostName = "nixos"; # Define your hostname.
  networking.firewall.enable = true;

  # Localization
  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "es_ES.UTF-8";
  i18n.extraLocaleSettings = {
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
  services.xserver.xkb = {
    layout = "es";
  };


  # Printing
  services.printing.enable = false;

  # Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Me
  users.users.vicente = {
    isNormalUser = true;
    description = "Vicente";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
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
  };

  # Browsers
  programs.firefox.enable = true;

  # Pkgs
  environment.systemPackages = with pkgs; [
  vim							# Editor
  zsh							# Shell
  man-pages						# Man
  gcc							# C-Utils
  valgrind						# C-Utils
  gnumake						# C-Utils
  linuxHeaders						# C-Utils
  cmake							# C-Utils
  git							# Git
  brave							# Browser
  pciutils						# Utils
  usbutils						# Utils
  nasm							# Asembly
  docker						# Virtualisation
  go							# Go
  wget							# Networking
  iw							# Networking
  traceroute						# Networking
  wireshark						# Networking
  networkmanager					# Networking
  curl							# Networking
  gtk4							# Graphics
  linux-firmware					# Linux
  linux							# Linux
  ];

  # Enviroment vars
  environment.variables = {
    GTK_THEME = "Adwaita:dark"; #Dark theme
    VIM = "/etc/vim/vimrc";
    PRUEBA = "HOLA";
  };

  # Docker
  virtualisation.docker = {
	enable = true;
  };

  # Enviroment 
  environment.etc = {
    "gitconfig".text = ''
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
    "/.config/vim/vimrc" = {
        text = 
	''
	#GENERAL
	set number			# Show line numbers
	set no wrap			# Wrap lines
	set textwidth=100		# Line wrap (number of cols)
	set showmatch			# Highlight matching brace
	set spell			# Enable spell-checking
	set virtualedit=all		# Enable free-range cursor
	set ruler			# Show row and column ruler information
	set undolevels=1000		# Number of undo levels
	set backspace=indent,eol,start	# Backspace behaviour

 	#SEARCH
	set hlsearch			# Highlight all search results
	set smartcase			# Enable smart-case search
	set ignorecase			# Always case-insensitive
	set incsearch			# Searches for strings incrementally
 
	#INDENTATION
	set autoindent			# Auto-indent new lines
	set shiftwidth=4		# Number of auto-indent spaces
	set smartindent			# Enable smart-indent
	set smarttab			# Enable smart-tabs
	set softtabstop=4		# Number of spaces per Tab
	set noexpandtab
	'';
     };
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
  system.stateVersion = "25.05"; # Did you read the comment?

}
