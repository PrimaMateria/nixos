# ██████╗ ██████╗  ██████╗ ███████╗██╗██╗     ███████╗
# ██╔══██╗██╔══██╗██╔═══██╗██╔════╝██║██║     ██╔════╝
# ██████╔╝██████╔╝██║   ██║█████╗  ██║██║     █████╗  
# ██╔═══╝ ██╔══██╗██║   ██║██╔══╝  ██║██║     ██╔══╝  
# ██║     ██║  ██║╚██████╔╝██║     ██║███████╗███████╗
# ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚══════╝

{ config, pkgs, neovim-primamateria, ... }:

let
  customNeovim = neovim-primamateria.packages.x86_64-linux.customNeovim;
in
{
  home.packages = [
    customNeovim
    pkgs.unzip
    pkgs.htop
    pkgs.exa
    pkgs.bat
    pkgs.tldr
    pkgs.zoxide
    pkgs.fzf
    pkgs.entr
    # TODO: temporary for testing
    # pkgs.watson-jira-next
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "exa --color automatic --time-style long-iso";
      ll = "ls -lha";
      cat = "bat -p";
      n = "cd ~/dev/nixos; nvim";
    };
    initExtra = ''
      BLUE="\[$(tput setaf 4)\]"
      YELLOW="\[$(tput setaf 3)\]"
      RESET="\[$(tput sgr0)\]"

      PS1="''${BLUE}\w''${YELLOW}\$''${RESET} "

      export EDITOR=${pkgs.neovim}/bin/nvim
      export MANPAGER="less -R --use-color -Dd+y -Du+b"
      
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
}
