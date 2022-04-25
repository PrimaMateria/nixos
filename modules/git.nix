{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
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
