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
        "finapi-js-loader"
        "finapi-js-static-resources"
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
    tmux-work = "tmuxp load space fds fsr fwloader fwl wfui wfl";
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

  # This still doesn't work opened tmux windows. Maybe I could try to rename
  # the socket to fit the old name
  programs.bash.initExtra = ''
    #!/usr/bin/bash
    export WSL_INTEROP=
    for socket in /run/WSL/*; do
       if ss -elx | grep -q "$socket"; then
          export WSL_INTEROP=$socket
       else
          rm $socket 
       fi
    done
    if [[ -z $WSL_INTEROP ]]; then
       echo -e "\033[31mNo working WSL_INTEROP socket found !\033[0m" 
    fi
  '';

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

    "tmuxp/fsr.yml".text = ''
      session_name: fsr
      shell_command_before: nix-shell ~/dev/nixos/shell.react.nix
      start_directory: ~/dev/finapi-js-static-resources
      windows:
        - window_name: IDE
          panes:
            - echo ""
    '';

    "tmuxp/fjsl.yml".text = ''
      session_name: fjsl
      shell_command_before: nix-shell ~/dev/nixos/shell.react.nix
      start_directory: ~/dev/finapi-js-loader
      windows:
        - window_name: IDE
          panes:
            - echo nvim
    '';

    "tmuxp/fwl.yml".text = ''
      session_name: fwl
      shell_command_before: nix-shell ~/dev/nixos/shell.react.nix
      start_directory: ~/dev/finapi-widget-library
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

    "tmuxp/fhp.yml".text = ''
      session_name: fhp
      shell_command_before: nix-shell ~/dev/nixos/shell.react.nix
      start_directory: ~/dev/finapi-hostpages/
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
