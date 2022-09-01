{ config, pkgs, ... }:

let
  git-clone-work-repos = pkgs.writeShellApplication {
    name = "git-clone-work-repos";
    runtimeInputs = [ pkgs.bash pkgs.git ];
    text = ''
      #!/bin/bash

      function clone() {
        project=$1
        repo=$2

        echo 
        if [ ! -d "./$project" ]; then
          echo "Cloning $project."
          git clone "$repo"
        else
          echo "$project already exists."
        fi
      }

      function clone-teaminvest() {
        project=$1
        clone "$project" "git@bitbucket.org:teaminvest/$project.git"
      }

      function clone-primamateria() {
        project=$1
        clone "$project" "git@github.com:PrimaMateria/$project.git"
      }

      declare -a workprojects=(
        "finapi-build-library"
        "finapi-cms"
        "finapi-design-system"
        "finapi-girocheck"
        "finapi-giroident-ui"
        "finapi-process-ctrl"
        "finapi-widget-library"
        "web-form"
        "web-form-loader"
      )

      for project in "''${workprojects[@]}"
      do
        clone-teaminvest "$project"
      done

      declare -a primamateriaprojects=(
        "direflow"
        "direflow-flake"
      )

      for project in "''${primamateriaprojects[@]}"
      do
        clone-primamateria "$project"
      done
    '';
  };
in
{
  home.packages = [
    pkgs.firefox
    pkgs.jetbrains.idea-ultimate
    pkgs.inkscape
    pkgs.watson
    git-clone-work-repos
  ];

  programs.bash.shellAliases = {
    tmux-work = "tmuxp load space fds fwl-loader fwl-widgets processctl wfui wfl";
    shell-react = "nix-shell ~/dev/nixos/shell.react.nix";
    shell-java = "nix-shell ~/dev/nixos/shell.java.nix";
    "@a" = "$HOME/reporting/watson-add.sh";
    "@w" = "$HOME/reporting/watson-add-webform.sh";
    "@ws" = "$HOME/reporting/watson-add-webform-sprint.sh";
    "@wo" = "$HOME/reporting/watson-add-webform-other.sh";
    "@fs" = "$HOME/reporting/watson-add-fraudpool-sprint.sh";
    "@fo" = "$HOME/reporting/watson-add-fraudpool-other.sh";
    "@do" = "$HOME/reporting/watson-add-di-other.sh";
    "@ds" = "$HOME/reporting/watson-add-di-sprint.sh";
    "@n" = "$HOME/reporting/watson-add-none.sh";
    "@b" = "$HOME/reporting/watson-add-break.sh";
    "@" = "watson";
  };

  xdg.configFile = { 
    "tmuxp/space.yml".text = ''
      session_name: space
      windows:
        - window_name: reporting
          layout: even-vertical
          start_directory: ~/reporting/
          panes:
            - ./current2
            - nix develop
        - window_name: todo
          start_directory: ~/Documents/
          panes:
            - nvim todo.md
        - window_name: nix
          start_directory: ~/dev/nixos/
          panes:
            - echo nvim flake.nix
        - window_name: neovim
          start_directory: ~/dev/neovim-nix/
          panes:
            - echo nvim flake.nix
        - window_name: x
          panes:
            - alias runx="xinit /home/mbenko/.vnc/xstartup -- $(realpath $(which Xvnc)) :1 PasswordFile=/home/mbenko/.vnc/passwd"
    '';

    "tmuxp/fds.yml".text = ''
      session_name: fds
      shell_command_before: nix-shell ~/dev/nixos/shell.react.nix
      start_directory: ~/dev/finapi-design-system/
      windows:
        - window_name: IDE
          panes:
            - echo nvim package.json
        - window_name: exec
          panes:
            - echo npm start
            - echo npm run storybook
    '';

    "tmuxp/fwl-loader.yml".text = ''
      session_name: fwl-loader
      shell_command_before: nix-shell ~/dev/nixos/shell.react.nix
      start_directory: ~/dev/finapi-widget-library/loader
      windows:
        - window_name: IDE
          panes:
            - echo nvim
        - window_name: exec
          panes:
            - echo npm start
            - echo npm run storybook
    '';

    "tmuxp/fwl-widgets.yml".text = ''
      session_name: fwl-widgets
      shell_command_before: nix-shell ~/dev/nixos/shell.react.nix
      start_directory: ~/dev/finapi-widget-library/widgets
      windows:
        - window_name: IDE
          panes:
            - echo nvim
        - window_name: exec
          panes:
            - echo npm start
    '';

    "tmuxp/wfui.yml".text = ''
      session_name: wfui
      shell_command_before: nix-shell ~/dev/nixos/shell.react.nix
      start_directory: ~/dev/web-form/frontend/
      windows:
        - window_name: IDE
          panes:
            - echo "nvim"
        - window_name: exec
          panes:
            - echo "npm start"
    '';

    "tmuxp/wfl.yml".text = ''
      session_name: wfl
      shell_command_before: nix-shell ~/dev/nixos/shell.react.nix
      start_directory: ~/dev/web-form-loader/
      windows:
        - window_name: IDE
          panes:
            - echo "nvim"
    '';

    "tmuxp/processctl.yml".text = ''
      session_name: processctl
      shell_command_before: nix-shell ~/dev/nixos/shell.java.nix
      start_directory: ~/dev/finapi-process-ctrl/
      windows:
        - window_name: IDE
          panes:
            - echo "nvim"
        - window_name: exec
          panes:
            - echo "docker-compose -f ./devops/docker-compose-local.yaml up --build --force-recreate --no-deps -d"
    '';
  };
}
