{ config, pkgs, pkgs-unstable, ... }:

let
  secrets = import ../.secrets/mbenko.nix;

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
        "finapi-hostpages"
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
  firefox = pkgs.writeShellApplication {
    name = "firefox";
    text = ''
      /mnt/c/Program\ Files/Mozilla\ Firefox/firefox.exe "$@"
    '';
  };
in
{
  home.packages = [
    pkgs.jetbrains.idea-ultimate
    pkgs.mycli
    git-clone-work-repos
    firefox
  ];

  programs.bash.shellAliases = {
    tmux-work = "tmuxp load space fds fwl wf fjsl wfl fhp";
    tmux-gg = "tmuxp load gg hive";
    shell-react = "nix-shell ~/dev/nixos/shell.react.nix";
    shell-java = "nix-shell ~/dev/nixos/shell.java.nix";
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
    export JIRA_API_TOKEN=${secrets.jiraApiToken}
  '';
  # todo: move JIRA token to reporting flake

  xdg.configFile = {
    ".jira.d/config.yml".text = ''
      endpoint: https://finapi.jira.com
      user: matus.benko@finapi.io
      authentication-method: api-token
    '';

    "tmuxp/space.yml".text = ''
      session_name: F1 space
      windows:
        - window_name: reporting
          layout: even-horizontal
          start_directory: ~/reporting/
          panes:
            - nix develop --command ./current2
            - nix develop
        - window_name: todo
          start_directory: ~/Documents/
          panes:
            - alias run="nvim todo.md"
        - window_name: nix
          start_directory: ~/dev/nixos/
          panes:
            - alias run="nvim flake.nix"
        - window_name: neovim
          start_directory: ~/dev/neovim-nix/
          panes:
            - alias run="nvim flake.nix"
        - window_name: devj
          start_directory: ~/dev/dev-journal
          panes:
            - alias run="nvim snt/in/Work.txt"
        - window_name: x
        - window_name: ambients
          start_directory: ~/Music/mp3
          panes:
            - cmus
        - window_name: newsboat
          layout: main-vertical
          start_directory: ~/
          panes:
            - chatblade -i
            - newsboat
            - nix-shell ~/dev/nixos/shell.react.nix --run "npx mapscii"
    '';

    "tmuxp/fds.yml".text = ''
      session_name: F2 fds
      start_directory: ~/dev/finapi-design-system/
      windows:
        - window_name: IDE
          panes:
            - clear
        - window_name: exec
          panes:
            - shell-react
    '';

    "tmuxp/fwl.yml".text = ''
      session_name: F3 fwl
      start_directory: ~/dev/finapi-widget-library
      windows:
        - window_name: IDE
          panes:
            - clear
        - window_name: exec
          panes:
            - shell-react
    '';

    "tmuxp/wf.yml".text = ''
      session_name: F4 wf
      start_directory: ~/dev/web-form/frontend/
      windows:
        - window_name: IDE
          panes:
            - clear
        - window_name: exec
          panes:
            - shell-react
    '';

    "tmuxp/fjsl.yml".text = ''
      session_name: F7 fjsl
      start_directory: ~/dev/finapi-js-loader
      windows:
        - window_name: IDE
          panes:
            - echo nvim
    '';

    "tmuxp/wfl.yml".text = ''
      session_name: F8 wfl
      start_directory: ~/dev/web-form-loader/
      windows:
        - window_name: IDE
          panes:
            - echo "nvim"
    '';

    "tmuxp/fhp.yml".text = ''
      session_name: F9 fhp
      start_directory: ~/dev/finapi-hostpages/
      windows:
        - window_name: IDE
          panes:
            - echo "nvim"
    '';

    "tmuxp/fjssr.yml".text = ''
      session_name: fjssr
      start_directory: ~/dev/finapi-js-static-resources
      windows:
        - window_name: IDE
          panes:
            - echo ""
    '';

    "tmuxp/cms.yml".text = ''
      session_name: cms
      start_directory: ~/dev/finapi-cms/
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

    "tmuxp/gg.yml".text = ''
      session_name: F1 gg
      windows:
        - window_name: nix
          start_directory: ~/dev/nixos/
          panes:
            - alias run="nvim flake.nix"
        - window_name: neovim
          start_directory: ~/dev/neovim-nix/
          panes:
            - alias run="nvim flake.nix"
        - window_name: x
        - window_name: ambients
          start_directory: ~/Music/mp3
          panes:
            - cmus
        - window_name: newsboat
          layout: main-vertical
          start_directory: ~/
          panes:
            - chatblade -i
            - newsboat
            - nix-shell ~/dev/nixos/shell.react.nix --run "npx mapscii"
        - window_name: weechat
          start_directory: ~/
          panes:
            - weechat
    '';

    "tmuxp/hive.yml".text = ''
      session_name: F2 hive
      start_directory: ~/dev/experiment-hive
      windows:
        - window_name: IDE
          panes:
            - echo ""
    '';
  };
}
