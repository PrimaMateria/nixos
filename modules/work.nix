{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.firefox
    pkgs.jetbrains.idea-ultimate
  ];

  programs.bash.shellAliases = {
    foo = "echo bar";
  };

  xdg.configFile = { 
    "tmuxp/fds.yml".text = ''
      session_name: fds
      shell_command_before: nix-shell ~/dev/nixos/shell.react.nix
      start_directory: ~/dev/finapi-design-system/
      windows:
        - window_name: IDE
          panes:
            - nvim
        - window_name: exec
          panes:
            - npm start
    '';

    "tmuxp/fwl.yml".text = ''
      session_name: fwl
      shell_command_before: nix-shell ~/dev/nixos/shell.react.nix
      start_directory: ~/dev/finapi-widget-library/
      windows:
        - window_name: IDE
          panes:
            - nvim
        - window_name: exec
          panes:
            - npm start
            - npm run storybook
    '';
  };
}
