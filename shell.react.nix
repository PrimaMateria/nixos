with (import <nixpkgs> {});
let
  workSecrets = import .secrets/work.nix;
  workNpmRC = pkgs.writeText "work-npmrc" ''
    prefix=~/.npm-global
    init-author-name=Matus Benko
    email=${workSecrets.email}

    //registry.npmjs.org/:_authToken=${workSecrets.npmjsAuthToken}
  
    ${workSecrets.internalNpmRegistry}
  '';
  nixos-playwright = stdenv.mkDerivation {
    pname = "nixos-playwright";
    version = "0.0.1";
    src = fetchgit {
      url = "https://github.com/ludios/nixos-playwright";
      sha256 = "1yb4dx67x3qxs2842hxhhlqb0knvz6ib2fmws50aid9mzaxbl0w0";
      rev = "fdafd9d4e0e76bac9283c35a81c7c0481a8b1313";
    };
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cd $out/bin && cp $src/* .
    '';
  };
in
mkShell {
  name = "react-shell";
  buildInputs = [ 
    nodejs-16_x
    nodePackages.typescript-language-server

    luakit
    google-chrome-dev
    firefox-bin
    nixos-playwright
  ];
  shellHook = ''
    alias npm="npm --userconfig ${workNpmRC}"

    if [ ! -d "$HOME/.npm-global" ]; then 
      mkdir "$HOME/.npm-global" 
      echo "Created ~/.npm-global"

      npm install -g @fsouza/prettierd eslint_d
      echo "Installed prettierd and eslint_d"
    fi
    
    export PATH="$HOME/.npm-global/bin:$PATH"

    export DISPLAY=:1
    export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true

    playwright-install () {
      #npm install -D playwright
      npx playwright install
      fix-playwright-browsers
    }
  '';
}
