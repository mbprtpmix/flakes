# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./fonts.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s20u2.useDHCP = true;
  networking.interfaces.enp8s0.useDHCP = true;
  networking.interfaces.wlp9s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.videoDrivers = [ "intel" "ati" "amdgpu" ];

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  services.xserver.displayManager.lightdm.greeters.gtk.theme.name = "Sweet-Dark";
  services.xserver.displayManager.lightdm.greeters.gtk.iconTheme.name = "Arc";
  services.xserver.displayManager.lightdm.greeters.gtk.cursorTheme.name = "Capitaine Cursors";
  services.xserver.displayManager.lightdm.greeters.gtk.clock-format = "%H:%M";
  services.xserver.displayManager.lightdm.background = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/mbprtpmix/nixos/testing/wallpapers/mountains.jpg";
    sha256 = "0k7lpj7rlb08bwq3wy9sbbq44rml55jyp9iy4ipwzy4bch0mc6y4";
  };
  services.xserver.displayManager.lightdm.greeters.gtk.indicators = [
    "~clock" "~spacer" "~host" "~spacer" "~power"
  ];
  services.xserver.displayManager.lightdm.greeters.gtk.extraConfig = ''
    font-name = Unifont 12
  '';
  
  nixpkgs.overlays = [
    (import ../overlays/packages.nix)
  ];

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  # Configure keymap in X11
  services.xserver.layout = "gb";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  # hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.support32Bit = true;
  
  services.pipewire = {
    enable = true;
    pulse = {
      enable = true;
    };
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack = {
      enable = true;
    };
  };

  hardware.cpu.intel.updateMicrocode = true;

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mbpnix = {
    isNormalUser = true;
    uid = 1000;
    hashedPassword = "$6$vAnCJagYjSels0M$hmd87xvjT2QW2Wa2PAt5SI/yomr/pUgXEVe3Rx1SvHBxMDRlE5gmydhaMzUzPeWR9bpiB.6MYfGlpxZYc1MYc0";
    description = "MBPNIX";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };
  
  programs.qt5ct.enable = true;
  
  programs.bash = {
    enableCompletion = true;
    enableLsColors = true;
    interactiveShellInit = ''
      bind "set completion-ignore-case on"
    '';
    shellAliases = {
    x="xclip -selection c -i";      # Cut	(does not filter).
    c="xclip -selection c -i -f";		# Copy	(does filter).
    v="xclip -selection c -o";      # Paste.
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    arc-icon-theme
    arc-theme
    capitaine-cursors
    sweet
    bleachbit
    firefox
    git
    git-crypt
    vim
    wget
    xclip
    cached-nix-shell
    cachix
  ];
  
  environment.shells = [ pkgs.zsh ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    storageDriver = "overlay2";
  };

  nix = {
    # package = pkgs.nixUnstable;
    # extraOptions = ''
    #   experimental-features = nix-command flakes ca-references
    # '';
    useSandbox = true;
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    binaryCaches = [
      "https://cache.nixos.org"
      "https://cachix.cachix.org"
      "https://nix-community.cachix.org"
      "https://fufexan.cachix.org"
      "https://mbpnix.cachix.org"
    ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "fufexan.cachix.org-1:LwCDjCJNJQf5XD2BV+yamQIMZfcKWR9ISIFy5curUsY="
      "mbpnix.cachix.org-1:nAfBijPdJRqcMhwDlIr4LbwPPKVWHROKx02Bcc/WbAI="
    ];
    trustedUsers = [ "root" "mbpnix" ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # services.ntp.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [  ];
  networking.firewall.allowedUDPPorts = [  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}

