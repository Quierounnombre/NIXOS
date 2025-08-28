# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  #SAVE VSCODE SSH ISSUE
  programs.nix-ld.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "vicxos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network paaroxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "es";
    variant = "nodeadkeys";
  };

  # Configure console keymap
  console.keyMap = "es";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vicente = {
    isNormalUser = true;
    description = "vicente";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

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
  };
  
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  gcc
  zsh
  python3
  python3Packages.django
  cmake
  valgrind
  man-pages
  gnumake 
  vscode
  linuxHeaders
  gnumake
  git
  brave
  traceroute
  wireshark
  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
	services.openssh.enable = true;

  # Open ports in the firewall.
	networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
