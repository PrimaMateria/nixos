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
in
mkShell {
  name = "react-shell";
  buildInputs = [ 
    nodejs-16_x
    nodePackages.typescript-language-server
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
  '';
}
