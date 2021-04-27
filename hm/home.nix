{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # gh
  programs.gh = {
    enable = true;
    gitProtocol = "ssh";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # nvim
  programs.neovim = {
    enable = true;
    vimAlias = true;
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
    settings = { PASSWORD_STORE_DIR = "$HOME/.local/share/password-store"; };
  };

  # gpg
  programs.gpg = {
    enable = true;
    settings = { homedir = "$HOME/.local/share/gnupg"; };
  };

  # gpg-agent
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 60;
    defaultCacheTtlSsh = 60;
    pinentryFlavor = "gtk2";
  };

  # git
  programs.git = {
    enable = true;
    userEmail = "mbprtpmix@gmail.com";
    userName = "mbprtpmix";
    signing = {
      key = "C24865FD";
      signByDefault = true;
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
    lsd
    neofetch
    nettools
    nmap
    nordic
    numix-gtk-theme
    numix-solarized-gtk-theme
    obs-studio
    orchis
    p7zip
    pinentry-gtk2
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
    vscodium
    vlc
    xarchiver
    xclip
    youtube-dl
  ];
}
