with (import <nixpkgs> {});
mkShell {
  buildInputs = [ 
    nodejs-16_x
  ];
  shellHook = ''
    alias npm="npm --userconfig ~/dev/nixos/.secrets/npmrc-work"
  '';
}
