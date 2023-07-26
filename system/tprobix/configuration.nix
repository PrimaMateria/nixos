# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  hostname = "tprobix";
  core = import ../modules/core.nix {
    inherit config pkgs hostname;
  };
  displaySetupScript = pkgs.writeShellApplication {
    name = "displaySetupScript";
    text = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --mode 2560x1440 --rate 143.86 --primary
      ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-0 --off
    '';
  };
in
{
  imports = [
    ./hardware-configuration.nix
    core
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.consoleMode = "max";
    efi.canTouchEfiVariables = true;
    timeout = 10000;
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  #networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.enp3s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.screenSection = ''
    Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
    Option         "AllowIndirectGLXProtocol" "off"
    Option         "TripleBuffer" "on"
  '';

  services.xserver.inputClassSections = [
    ''
      Identifier      "Logitech G502 HERO Gaming Mouse sensitivity"
      MatchProduct    "Logitech G502 HERO Gaming Mouse"
      MatchIsPointer  "true"
      Option          "ConstantDeceleration" "3"
      Driver          "evdev"
    ''
  ];

  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.displayManager.lightdm = {
    enable = true;
    extraSeatDefaults = ''
      display-setup-script = ${displaySetupScript}/bin/displaySetupScript
    '';
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin ];

  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.reflector = true;

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];
  hardware.sane.netConf = "192.168.178.31";

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Service for configuring gaming mouse
  services.ratbagd.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  users.users.primamateria = {
    isNormalUser = true;
    extraGroups = [ "docker" "wheel" "audio" "video" "networkmanager" "disk" "scanner" "lp" ];
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
    rclone
    tzdata
  ];

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # File manager
  programs.thunar.enable = true;

  #  fileSystems."/mnt/caladan" =
  #    { device = "/dev/disk/by-uuid/4DF0BBED38D45117";
  #      fsType = "ntfs";
  #      options = [ "defaults" "user" "rw" "utf8" "umask=000" "nofail" ];
  #    };

  fileSystems."/mnt/giediprime" =
    {
      device = "/dev/disk/by-uuid/1251-D91F";
      fsType = "exfat";
      options = [ "defaults" "user" "rw" "utf8" "umask=000" "nofail" ];
    };

  fileSystems."/mnt/c" =
    {
      device = "/dev/disk/by-uuid/6C8A776F8A773524";
      fsType = "ntfs";
      options = [ "defaults" "user" "rw" "utf8" "umask=000" "nofail" ];
    };
}

