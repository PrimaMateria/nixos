{ config, pkgs, pkgs-unstable, ... }:

{

  home.packages = with pkgs; [
    enpass
    spotify
    mpv
    element-desktop
    obs-studio
    gnome.simple-scan
    flameshot
    nomacs # picture viewer
    slack
    libreoffice
    skypeforlinux
    gimp
    piper # client for ratbagd
  ] ++ (with pkgs-unstable; [
    discord
  ]);

  programs.sioyek = {
    enable = true;
    bindings = {
      "move_up" = "k";
      "move_down" = "j";
      "move_left" = "h";
      "move_right" = "l";
    };

    config = {
      search_url_g = "https://duckduckgo.com/?q=";
      search_url_t = "https://translate.google.com/?sl=auto&tl=en&op=translate&text=";
      search_url_m = "https://www.google.com/maps/search/?api=1&query=";
      search_url_i = "https://duckduckgo.com/?iax=images&ia=images&q=";
      search_url_w = "https://en.wikipedia.org/wiki/Special:Search?go=Go&search=";
      search_url_d = "https://www.wortbedeutung.info/?query=";
      search_url_e = "https://www.dictionary.com/browse/";
    };
  };
}
