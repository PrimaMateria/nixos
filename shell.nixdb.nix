with (import <nixpkgs> {});
mkShell {
  buildInputs = [ 
    sqlite
    rlwrap
  ];
  shellHook = ''
    echo "----------------------------------------"
    echo "Shell for working with nix sqlite db"
    echo "----------------------------------------"
    echo "narSize/1024/1024 - derivation size in MB"
    echo "datetime(registrationTime, 'unixepoch')"
    echo "----------------------------------------"
    echo

    sudo rlwrap sqlite3 /nix/var/nix/db/db.sqlite -box
  '';
}
