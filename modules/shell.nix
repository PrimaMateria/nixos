# ██████╗ ██████╗  ██████╗ ███████╗██╗██╗     ███████╗
# ██╔══██╗██╔══██╗██╔═══██╗██╔════╝██║██║     ██╔════╝
# ██████╔╝██████╔╝██║   ██║█████╗  ██║██║     █████╗  
# ██╔═══╝ ██╔══██╗██║   ██║██╔══╝  ██║██║     ██╔══╝  
# ██║     ██║  ██║╚██████╔╝██║     ██║███████╗███████╗
# ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚══════╝

{ config, pkgs, pkgs-unstable, neovim-primamateria, ... }:

let
  customNeovim = neovim-primamateria.packages.x86_64-linux.neovimPrimaMateriaWrapper;
  spotifySecrets = import ../.secrets/spotify.nix;
  chatgptSecrets = import ../.secrets/chatgpt.nix;
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
    cmus
    sptlrx
    glow
    sc-im
  ] ++ (with pkgs-unstable;
    [
      chatblade
    ]);

  xdg.configFile."sptlrx/config.yaml".text = ''
    cookie: "${spotifySecrets.cookie}"
    player: spotify
    timerInterval: 200
    updateInterval: 2000
    style:
      hAlignment: center
      before:
        background: ""
        foreground: ""
        bold: true
        italic: false
        undeline: false
        strikethrough: false
        blink: false
        faint: false
      current:
        background: ""
        foreground: ""
        bold: true
        italic: false
        undeline: false
        strikethrough: false
        blink: false
        faint: false
      after:
        background: ""
        foreground: ""
        bold: false
        italic: false
        undeline: false
        strikethrough: false
        blink: false
        faint: true
    pipe:
      length: 0
      overflow: word
      ignoreErrors: true
    mpd:
      address: 127.0.0.1:6600
      password: ""
    mopidy:
      address: 127.0.0.1:6680
  '';

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
      export OPENAI_API_KEY=${chatgptSecrets.apiKey}
      
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
