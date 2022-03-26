{
  description = "Prima Materia";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    dmenu-primamateria.url = "github:PrimaMateria/dmenu";
    dmenu-primamateria.inputs.nixpkgs.follows = "nixpkgs";

    i3blocks-gcalcli.url = "github:PrimaMateria/i3blocks-gcalcli";
    i3blocks-gcalcli.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, dmenu-primamateria, i3blocks-gcalcli, ... }: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
    lib = nixpkgs.lib;

  in {
    overlay = import ./overlays/overlay-i3.nix;

    homeManagerConfigurations = {
      primamateria = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;
        username = "primamateria";
        homeDirectory = "/home/primamateria";
        stateVersion = "21.11";
        extraSpecialArgs = { inherit dmenu-primamateria i3blocks-gcalcli; };
        configuration = {
          imports = [
            { nixpkgs.overlays = [ self.overlay ]; }
            ./modules/main.nix
            ./modules/shell.nix
            ./modules/i3.nix
            ./modules/alacritty.nix
            ./modules/tmux.nix
            ./modules/nvim
            ./modules/vifm.nix
            ./modules/weechat.nix
            ./modules/newsboat.nix
          ];
        };
      };
    };

    nixosConfigurations = {
      tprobix = lib.nixosSystem {
        inherit system;

        modules = [
          { nixpkgs.overlays = [ self.overlay ]; }
          ./system/configuration.nix
          ./services/usenet.nix
          ./services/rclone.nix
        ];
      };
    };
  };
}
