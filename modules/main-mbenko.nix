{ config, pkgs, ... }:

{
  home.username = "mbenko";
  home.homeDirectory = "/home/mbenko";
  home.stateVersion = "21.11";
  
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
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
