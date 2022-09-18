{
  description = "Prima Materia";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    dmenu-primamateria.url = "github:PrimaMateria/dmenu";
    dmenu-primamateria.inputs.nixpkgs.follows = "nixpkgs";

    i3blocks-gcalcli.url = "github:PrimaMateria/i3blocks-gcalcli";
    i3blocks-gcalcli.inputs.nixpkgs.follows = "nixpkgs";

    neovim-primamateria.url = "github:PrimaMateria/neovim-nix";

    watson-jira-next.url = "github:PrimaMateria/watson-jira-next";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, dmenu-primamateria, i3blocks-gcalcli, neovim-primamateria, watson-jira-next, ... }: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
    lib = nixpkgs.lib;
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config = { allowUnfree = true; };
    };

  in {
    overlay = import ./overlays/overlay-i3.nix;

    homeManagerConfigurations = {
      primamateria = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;
        username = "primamateria";
        homeDirectory = "/home/primamateria";
        stateVersion = "22.05";
        extraSpecialArgs = {
          inherit dmenu-primamateria i3blocks-gcalcli pkgs-unstable neovim-primamateria; 
        };
        configuration = {
          programs.home-manager.enable = true;
          home.username = "primamateria";
          home.homeDirectory = "/home/primamateria";
          home.stateVersion = "22.05";

          imports = [
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
          ];
        };
      };

      mbenko = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;
        username = "mbenko";
        homeDirectory = "/home/mbenko";
        stateVersion = "22.05";
        extraSpecialArgs = {
          inherit neovim-primamateria watson-jira-next pkgs-unstable;
        };
        configuration = {
          programs.home-manager.enable = true;
          home.username = "mbenko";
          home.homeDirectory = "/home/mbenko";
          home.stateVersion = "22.05";
          nixpkgs.config.allowUnfree = true;

          imports = [
            ./modules/git.nix
            ./modules/shell.nix
            ./modules/tmux.nix
            ./modules/vifm.nix
            ./modules/weechat.nix
            ./modules/ssh.nix
            ./modules/work.nix
            ./modules/reporting.nix
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
