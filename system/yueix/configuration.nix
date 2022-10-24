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
    interop.register = true;
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

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (self: super: {
      docker = super.docker.override { iptables = pkgs.iptables-legacy; };
    })
  ];

  virtualisation.docker.enable = true;
  users.users.mbenko.extraGroups = [ "docker" "wheel" "audio" "video" "networkmanager" "disk" "scanner" "lp" ];

  services.xserver.enable = true;
  services.xserver.layout = "us,sk,de";
  services.xserver.xkbVariant = ",qwerty,qwerty";
  services.xserver.xkbOptions = "grp:lctrl_lwin_toggle";
  # services.xserver.desktopManager.xterm.enable = true;
  # services.xserver.windowManager.i3.enable = true;
  services.x2goserver.enable = true;

  services.xserver.autorun = false;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.displayManager.gdm.enable = true;

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
  ];

  environment.systemPackages = with pkgs; [
     tigervnc 
     xorg.xinit
     docker-compose
     tzdata
  ];
  system.stateVersion = "21.11";
}
