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
    export PATH="$HOME/.npm-global/bin:$PATH"
  '';
}
