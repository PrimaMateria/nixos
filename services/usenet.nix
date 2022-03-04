{ config, pkgs, ... }:
{
  services.nzbget = {
    enable = true;
    settings = {
      MainDir = "/mnt/giediprime/nzb";
      RequiredDir= "/mnt/giediprime/nzb";
    } // import ../.secrets/nzbget.nix;
  };

  services.radarr = {
    enable = true;
  };

  services.sonarr = {
    enable = true;
  };
}
