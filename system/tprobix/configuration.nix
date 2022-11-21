# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{ imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  # Make ready for nix flakes
  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    package = pkgs.nixFlakes;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.consoleMode = "max";
    efi.canTouchEfiVariables = true;
    timeout = 10000;
  };

  networking.hostName = "tprobix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  #networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.enp3s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us,sk,de";
  services.xserver.xkbVariant = ",qwerty,qwerty";
  services.xserver.xkbOptions = "grp:lctrl_lwin_toggle";
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.screenSection = ''
    Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
    Option         "AllowIndirectGLXProtocol" "off"
    Option         "TripleBuffer" "on"
  '';

  services.xserver.desktopManager.xterm.enable = false;
  #services.xserver.displayManager.defaultSession = "none+i3";
  #services.xserver.displayManager.lightdm.greeters.mini = {
    #enable = true;
    #user = "primamateria";
    #extraConfig = ''
      #[greeter]
      #show-password-label = false
      #[greeter-theme]
      #background-image = ""
    #'';
  #};
  services.xserver.windowManager.i3.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  

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

  users.users.primamateria = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "networkmanager" "disk" "scanner" "lp" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
    rclone
    tzdata
  ];

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

#  fileSystems."/mnt/caladan" =
#    { device = "/dev/disk/by-uuid/4DF0BBED38D45117";
#      fsType = "ntfs";
#      options = [ "defaults" "user" "rw" "utf8" "umask=000" "nofail" ];
#    };

  fileSystems."/mnt/giediprime" =
    { device = "/dev/disk/by-uuid/1251-D91F";
      fsType = "exfat";
      options = [ "defaults" "user" "rw" "utf8" "umask=000" "nofail" ];
    };

  fileSystems."/mnt/c" =
    { device = "/dev/disk/by-uuid/6C8A776F8A773524";
      fsType = "ntfs";
      options = [ "defaults" "user" "rw" "utf8" "umask=000" "nofail" ];
    };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

