{ pkgs, myusers, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = myusers.jordy.username;
  home.homeDirectory = myusers.jordy.homeDirectory;

  imports = [ ./bash ./i3 ./urxvt ./nvim ./git ./fzf.nix ];

  home.packages = with pkgs; [

    # Utils
    complete-alias
    vivid
    feh
    htop
    tree
    unzip
    p7zip
    unrar-wrapper
    file
    dos2unix
    openssl
    jq
    xsel
    lazygit
    restic

    # Connectivity (Net & Bluetooth) utils
    curl
    wget
    inetutils
    dnsutils
    impala
    trayscale
    bluetui

    # Fonts
    meslo-lg
    (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; })

    # Browser
    brave
    firefox

    # Dev
    jetbrains.idea-community

    # Containers
    docker-compose

    # k8s
    kubectl
    kubecolor
    k9s

    # Audio
    ncpamixer
  ];

  fonts.fontconfig.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.gpg.enable = true;

  programs.ssh = {
    enable = true;
    extraConfig = ''
        SetEnv TERM=xterm

      Host localvm
        hostname 127.0.0.1
        user jordy
        port 2022
        StrictHostKeyChecking no
    '';
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };

  # Services
  services.gpg-agent = {
    enable = true;
    enableBashIntegration = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  services.mpris-proxy.enable = true;
}
