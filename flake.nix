{
  description = "Prima Materia";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    dmenu-primamateria.url = "github:PrimaMateria/dmenu";
    dmenu-primamateria.inputs.nixpkgs.follows = "nixpkgs";

    i3blocks-gcalcli.url = "github:PrimaMateria/i3blocks-gcalcli";
    i3blocks-gcalcli.inputs.nixpkgs.follows = "nixpkgs";

    watson-jira-next.url = "github:PrimaMateria/watson-jira-next";

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, dmenu-primamateria, i3blocks-gcalcli, watson-jira-next, nur, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = { allowUnfree = true; };
      };

      nur-pkgs = import nur {
        nurpkgs = pkgs;
        pkgs = pkgs;
      };

      lib = nixpkgs.lib;

      # This overlay is added before nixos configuration to be able to access unstable packages
      overlay-unstable = final: prev: {
        unstable = pkgs-unstable;
      };

    in
    {
      overlay = import ./overlays/overlay-i3.nix;

      homeManagerConfigurations = {
        primamateria = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit dmenu-primamateria i3blocks-gcalcli pkgs-unstable nur-pkgs;
          };
          modules = [
            {
              home = {
                username = "primamateria";
                homeDirectory = "/home/primamateria";
                stateVersion = "22.05";
              };
            }
            { nixpkgs.overlays = [ self.overlay ]; }
            ./modules/desktop.nix
            ./modules/git.nix
            ./modules/shell.nix
            ./modules/i3.nix
            ./modules/alacritty.nix
            ./modules/tmux.nix
            ./modules/vifm.nix
            ./modules/weechat.nix
            ./modules/newsboat.nix
            ./modules/ssh.nix
            ./modules/gaming.nix
          ];
        };

        mbenko = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit watson-jira-next pkgs-unstable;
          };
          modules = [
            {
              home = {
                username = "mbenko";
                homeDirectory = "/home/mbenko";
                stateVersion = "22.05";
              };
            }
            { nixpkgs.overlays = [ self.overlay ]; }
            ./modules/git.nix
            ./modules/shell.nix
            ./modules/tmux.nix
            ./modules/vifm.nix
            ./modules/weechat.nix
            ./modules/ssh.nix
            ./modules/vnc.nix
            ./modules/mbenko.nix
            ./modules/reporting.nix
          ];
        };

        benkma = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit pkgs-unstable;
          };
          modules = [
            {
              home = {
                username = "benkma";
                homeDirectory = "/home/benkma";
                stateVersion = "22.05";
              };
            }
            { nixpkgs.overlays = [ self.overlay ]; }
            ./modules/git.nix
            ./modules/shell.nix
            ./modules/tmux.nix
            ./modules/vifm.nix
            ./modules/weechat.nix
            ./modules/ssh.nix
            ./modules/vnc.nix
          ];
        };
      };

      nixosConfigurations = {
        tprobix = lib.nixosSystem {
          inherit system;
          modules = [
            { nixpkgs.overlays = [ self.overlay overlay-unstable ]; }
            ./system/tprobix/configuration.nix
            ./services/usenet.nix
            ./services/rclone.nix
          ];
        };

        yueix = lib.nixosSystem {
          inherit system;
          modules = [
            { nixpkgs.overlays = [ self.overlay overlay-unstable ]; }
            ./system/yueix/configuration.nix
          ];
        };
      };
    };
}
