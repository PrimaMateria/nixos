# ██████╗ ██████╗  ██████╗ ███████╗██╗██╗     ███████╗
# ██╔══██╗██╔══██╗██╔═══██╗██╔════╝██║██║     ██╔════╝
# ██████╔╝██████╔╝██║   ██║█████╗  ██║██║     █████╗  
# ██╔═══╝ ██╔══██╗██║   ██║██╔══╝  ██║██║     ██╔══╝  
# ██║     ██║  ██║╚██████╔╝██║     ██║███████╗███████╗
# ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚══════╝

{ config, pkgs, pkgs-unstable, neovim-primamateria, ... }:

let
  customNeovim = neovim-primamateria.packages.x86_64-linux.neovimPrimaMateriaWrapper;
in
{
  home.packages = with pkgs; [
    unzip
    htop
    exa
    bat
    tldr
    zoxide
    fzf
    entr
    translate-shell
    lazygit
    lazydocker
    manix
    git-branch-clean
    http-prompt
    subdl
    jq
  ];

  programs.ncmpcpp = {
    enable = true;
    bindings = [
      { key = "j"; command = "scroll_down"; }
      { key = "k"; command = "scroll_up"; }
      { key = "l"; command = "previous_column"; }
      { key = "h"; command = "next_column"; }
      { key = "J"; command = [ "select_item" "scroll_down" ]; }
      { key = "K"; command = [ "select_item" "scroll_up" ]; }
      { key = "g"; command = "move_home"; }
      { key = "G"; command = "move_end"; }
      { key = "ctrl-f"; command = "page_down"; }
      { key = "ctrl-b"; command = "page_up"; }
      { key = "n"; command = "next_found_item"; }
      { key = "N"; command = "previous_found_item"; }
    ];
  };

  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music/mp3";
    extraConfig = ''
      audio_output {
        type  "pulse"
        name  "mpd pulse-audio-output"
      }
    '';
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "exa --color automatic --time-style long-iso";
      ll = "ls -lha";
      cat = "bat -p";
      # nvim = "nix run github:PrimaMateria/neovim-nix";
      nvim = "nix run ~/dev/neovim-nix --";
      n = "cd ~/dev/nixos; nvim";
      nn = "cd ~/dev/neovim-nix; nvim";
    };
    initExtra = ''
      # \001 (^A) start non-visible characters
      # \002 (^B) end non-visible characters

      BLUE="\001$(tput setaf 4)\002"
      YELLOW="\001$(tput setaf 3)\002"
      RESET="\001$(tput sgr0)\002"

      PS1="''${BLUE}\w''${YELLOW}\$''${RESET} "

      export EDITOR=${pkgs.neovim}/bin/nvim
      export MANPAGER="less -R --use-color -Dd+y -Du+b"
      export NIXPKGS_ALLOW_UNFREE=1
      
      eval "$(zoxide init bash)"

      #test -z ''${TMUX} && tmux new-session -A -s space
    '';
  };

  programs.readline = {
    enable = true;
    extraConfig = ''
      set colored-stats on
      set colored-completion-prefix on
      set show-all-if-ambiguous on
      set completion-ignore-case on
      set editing-mode vi
      set show-mode-in-prompt on
      set vi-ins-mode-string " "
      set vi-cmd-mode-string " "
    '';
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };
}
