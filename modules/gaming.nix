{ config, pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
  ] ++ (with pkgs-unstable; [
    wineWowPackages.stable
    winetricks
  ]);
}
