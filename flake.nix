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
          programs.home-manager.enable = true;
          home.username = "primamateria";
          home.homeDirectory = "/home/primamateria";
          home.stateVersion = "21.11";

          imports = [
            { nixpkgs.overlays = [ self.overlay ]; }
            ./modules/desktop.nix
            ./modules/git.nix
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

      mbenko = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;
        username = "mbenko";
        homeDirectory = "/home/mbenko";
        stateVersion = "21.11";
        configuration = {
          programs.home-manager.enable = true;
          home.username = "mbenko";
          home.homeDirectory = "/home/mbenko";
          home.stateVersion = "21.11";

          imports = [
            ./modules/git.nix
            ./modules/shell.nix
            ./modules/tmux.nix
            ./modules/nvim
            ./modules/vifm.nix
            ./modules/weechat.nix
          ];
        };
      };
    };

    nixosConfigurations = {
      tprobix = lib.nixosSystem {
        inherit system;
        modules = [
          { nixpkgs.overlays = [ self.overlay ]; }
          ./system/tprobix/configuration.nix
          ./services/usenet.nix
          ./services/rclone.nix
        ];
      };

      yueix = lib.nixosSystem {
      	inherit system;
        modules = [
          ./system/yueix/configuration.nix
        ];
      };
    };
  };
}
