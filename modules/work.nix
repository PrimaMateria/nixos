{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.slack
    pkgs.teams
  ];
}
