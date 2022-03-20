{ config, pkgs, ... }:

{
  home.username = "primamateria";
  home.homeDirectory = "/home/primamateria";
  home.stateVersion = "21.11";
  
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    enpass
    spotify
    mpv
    element-desktop
    discord
    obs-studio
    gnome.simple-scan
    flameshot

    # Wil T secrets in git
    git-crypt
    gnupg
    pinentry_qt
  ];

  programs.git = {
    enable = true;
    userName = "matus.benko";
    userEmail = "matus.benko@gmail.com";
  };

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "qt";
  };
}
