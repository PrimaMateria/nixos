{ config, pkgs, ... }:
{
  services.nzbget = {
    enable = true;
  };

  services.radarr = {
    enable = true;
  };

  services.sonarr = {
    enable = true;
  };
}
