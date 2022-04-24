# Notes

## Nix DB select

```
sudo sqlite3 /nix/var/nix/db/db.sqlite -header -column "select path,narSize/1024/1024,datetime(registrationTime,'unixepoch') from ValidPaths where narSize > (1024*1024*128) order by registrationTime desc limit 15;"
```

From all packages currently in the store order by time they were registered, fitler by 128MB size and show first 15 records.

Inside my nixos repository I have prepared nix-shell with sqlite3 client.

## Nix store query

```
nix-store -qR `readlink -f /run/current-system`
```

Query store and show **R**untime dependencies from the path which represents the current system.
Also interesting approach is to pass path of program like `$(which i3blocks)`.

## Nix shell for setting up HP printer

```
$ sudo nix-shell -p python3Packages.pyqt5 hplip
[nix-shell:~]# hp-setup
```

## Trivial builders

This good source to figure out how to bring small configs and utilities to the store: https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/trivial-builders.nix
