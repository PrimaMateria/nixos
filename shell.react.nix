with (import <nixpkgs> { });
let
  unstable = import (fetchTarball https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz) { };
  workSecrets = import .secrets/mbenko.nix;
  workNpmRC = pkgs.writeText "work-npmrc" ''
    prefix=~/.npm-global
    init-author-name=Matus Benko
    email=${workSecrets.email}

    //registry.npmjs.org/:_authToken=${workSecrets.npmjsAuthToken}
  
    ${workSecrets.internalNpmRegistry}
  '';

  testdebug = pkgs.writeShellApplication {
    name = "testdebug";
    runtimeInputs = [ fzf ];
    text = ''
      TARGET=$(find src -name "*.ts*"  -and -not -path '**/__test*__/**' -and -not -path '**/openapi/**'  | fzf)
      TARGETPATH="''${TARGET%/*}"
      COMPONENT=''${TARGET##*/}
      COMPONENT=''${COMPONENT%.tsx}
      COMPONENT=''${COMPONENT%.ts}
      TESTCASE="$TARGETPATH/__test__/$COMPONENT.unit.test.ts"

      npm run test:unit:debug -- --coverage --collectCoverageFrom "$TARGET" "$TESTCASE"
    '';
  };
in
mkShell {
  name = "react-shell";
  buildInputs = [
    unstable.nodejs-18_x
    testdebug
  ];
  shellHook = ''
    alias npm="npm --userconfig ${workNpmRC}"

    if [ ! -d "$HOME/.npm-global" ]; then 
      mkdir "$HOME/.npm-global" 
      echo "Created ~/.npm-global"
    fi
    
    export PATH="$HOME/.npm-global/bin:$PATH"

    export DISPLAY=:1
  '';
}
