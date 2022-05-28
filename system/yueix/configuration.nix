{ lib, pkgs, config, modulesPath, ... }:

with lib;
let
  nixos-wsl = import ./nixos-wsl;
  hostname = "yueix";
in
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    nixos-wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "mbenko";
    startMenuLaunchers = true;
    wslConf = {
      network = {
        hostname = hostname;
        generateResolvConf = "false";
      };
    };

    # Enable integration with Docker Desktop (needs to be installed)
    # docker.enable = true;
  };

  # Enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  time.timeZone = "Europe/Berlin";
  networking.hostName = hostname;

  environment.etc."resolv.conf" = {
    enable = true;
    source =  pkgs.writeText "resolv.conf" '' 
      nameserver 8.8.8.8
    '';
  };
  
  nixpkgs.overlays = [
    (self: super: {
      docker = super.docker.override { iptables = pkgs.iptables-legacy; };
    })
  ];

  virtualisation.docker.enable = true;
  users.users.mbenko.extraGroups = [ "docker" ];
}
