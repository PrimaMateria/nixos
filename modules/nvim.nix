{ pkgs, config, lib, ... }:
let
  plugin = { url, rev, sha256 }:
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = with lib; (last (splitString "/" url));
      version = rev;
      src = pkgs.fetchgit { inherit url rev sha256; };
    };
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = false;
    withPython3 = true;
    withRuby = false;
  };

  home.file = { 
    "nvim2" = {
      source = ./home/.config/nvim;
      target = ".config";
      recursive = true;
    };
  };

  #home.packages = with pkgs; [
  #];
}

