{ config, pkgs, hostname, username, ... }:
{
  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = username;
    startMenuLaunchers = true;
    interop.register = true;
    wslConf = {
      network = {
        inherit hostname;
        generateResolvConf = false;
      };
    };

    # Enable integration with Docker Desktop (needs to be installed)
    # docker.enable = true;
  };

  users.users.${username} = {
    homeMode = "755";
    extraGroups = [ "docker" "wheel" "audio" "video" "networkmanager" "disk" "scanner" "lp" ];
  };

  environment.etc."resolv.conf" = {
    enable = true;
    source = pkgs.writeText "resolv.conf" '' 
      nameserver 8.8.8.8
    '';
  };

  # nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (self: super: {
      docker = super.docker.override { iptables = pkgs.iptables-legacy; };
    })
  ];

  virtualisation.docker.enable = true;

  services.x2goserver.enable = true;
  services.xserver.autorun = false;
  services.xserver.windowManager.icewm.enable = true;
  services.xserver.displayManager.gdm.enable = true;

  environment.systemPackages = with pkgs; [
    tigervnc
    xorg.xinit
    docker-compose
    tzdata
  ];
}
