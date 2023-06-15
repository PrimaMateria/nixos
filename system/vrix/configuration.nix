{ lib, pkgs, config, modulesPath, ... }:

with lib;
let
  hostname = "vrix";
  username = "benkma";
  nixos-wsl = import ../modules/nixos-wsl;
  core = import ../modules/core.nix {
    inherit config pkgs hostname;
  };
  wsl = import ../modules/wsl.nix {
    inherit config pkgs hostname username;
  };
in
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    nixos-wsl.nixosModules.wsl
    core
    wsl
  ];

  # services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

}
