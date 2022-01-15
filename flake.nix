{
  description = "Prima Materia";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
    lib = nixpkgs.lib;

  in {
    homeManagerConfigurations = {
      primamateria = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;
        username = "primamateria";
        homeDirectory = "/home/primamateria";
	stateVersion = "21.11";
        configuration = {
          imports = [
            ./modules/main.nix
            ./modules/i3.nix
            ./modules/alacritty.nix
            ./modules/tmux.nix
            ./modules/nvim.nix
          ];
        };
      };
    };

    nixosConfigurations = {
      tprobix = lib.nixosSystem {
        inherit system;

        modules = [
          ./system/configuration.nix
        ];
      };
    };
  };
}
