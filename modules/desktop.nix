{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    enpass
    spotify
    mpv
    element-desktop
    discord
    obs-studio
    gnome.simple-scan
    flameshot
    zathura
    nomacs
    slack
    libreoffice
  ];
}
