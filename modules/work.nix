{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.firefox
    pkgs.jetbrains.idea-ultimate
  ];
}
