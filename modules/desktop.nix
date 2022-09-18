{ config, pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    enpass
    spotify
    mpv
    element-desktop
    obs-studio
    gnome.simple-scan
    flameshot
    zathura
    nomacs
    slack
    libreoffice
    skypeforlinux
    gimp
  ] ++ (with pkgs-unstable; [
    discord
  ]);
}
