{ config, pkgs, ... }:
{
  services.nzbget = {
    enable = true;
    settings = {
      MainDir = "/mnt/caladan/nzb";
      RequiredDir= "/mnt/caladan/nzb";
    } // import ../.secrets/nzbget.nix;
  };

  services.radarr = {
    enable = true;
  };

  services.sonarr = {
    enable = true;
  };
}
