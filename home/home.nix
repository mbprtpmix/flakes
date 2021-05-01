{ config, pkgs, ... }:

{
  imports = [
    ./modules/shell.nix
    ./modules/files.nix
    ./modules/zsh.nix
    ./modules/pkgs.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
  };

  services.emacs = {
    enable = true;
  };

  # gh
  programs.gh = {
    enable = true;
    gitProtocol = "ssh";
  };

  xdg.enable = true;

  gtk = {
    enable = true;
    iconTheme.name = "Arc";
    iconTheme.package = pkgs.arc-icon-theme;
    theme.name = "Sweet-Dark";
    theme.package = pkgs.sweet;
  };

  # nvim
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    extraConfig = ''
      syntax on
      set tabstop=2 softtabstop=2
      set shiftwidth=2
      set expandtab
      set smartindent
      set nu rnu
      set nowrap
      set smartcase
      set noswapfile
      set nobackup
      set undodir=~/.vim/undodir
      set undofile
      set colorcolumn=80
      highlight ColorColumn ctermbg=0 guibg=lightgrey
      colorscheme gruvbox
      set background=dark
    '';
    plugins = [
      pkgs.vimPlugins.vim-nix
      pkgs.vimPlugins.gruvbox
    ];
  };

  # pass
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    settings = { PASSWORD_STORE_DIR = "~/.password-store"; };
  };

  # gpg
  programs.gpg = {
    enable = true;
    settings = { homedir = "~/.gnupg"; };
  };

  # gpg-agent
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 60;
    defaultCacheTtlSsh = 60;
    maxCacheTtl = 60;
    maxCacheTtlSsh = 60;
    pinentryFlavor = "gtk2";
    sshKeys = [ "3E21A304C2321FD74847868EFFB8AE44A11963CA" ];
  };

  # git
  programs.git = {
    enable = true;
    userName = "mbprtpmix";
    userEmail = "mbprtpmix@gmail.com";
    signing = {
      signByDefault = true;
      key = "14E5A6EC";
    };
    extraConfig = {
      core.editor = "vim";
      github.username = "mbprtpmix";
      color.ui = true;
      pull.rebase = true;
      diff.algorithm = "patience";
    };
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "mbpnix";
  home.homeDirectory = "/home/mbpnix";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";

  # pkgs
  home.packages = with pkgs; [
    arc-icon-theme
    arc-theme
    arduino
    bat
    bc
    bleachbit
    capitaine-cursors
    discord
    etcher
    exa
    filezilla
    git-crypt
    google-cloud-sdk
    gruvbox-dark-gtk
    gruvbox-dark-icons-gtk
    hping
    htop
    i3lock-color
    i3lock-fancy
    keepassxc
    kotatogram-desktop
    vscodium
    atom
    lsd
    neofetch
    nettools
    nmap
    nordic
    numix-gtk-theme
    numix-solarized-gtk-theme
    numix-cursor-theme
    numix-icon-theme
    numix-icon-theme-circle
    numix-icon-theme-square
    numix-solarized-gtk-theme
    numix-sx-gtk-theme
    obs-studio
    pavucontrol
    orchis
    gimp
    inkscape
    p7zip
    pinentry-gtk2
    papirus-icon-theme
    procs
    ripgrep
    scrot
    speedtest-cli
    stow
    sweet
    tree
    unrar
    unzip
    vimix-gtk-themes
    vlc
    xarchiver
    xclip
    youtube-dl
  ];
}
