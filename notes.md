# Notes

## Nix DB select

```
sudo sqlite3 /nix/var/nix/db/db.sqlite -header -column "select path,narSize/1024/1024,datetime(registrationTime,'unixepoch') from ValidPaths where narSize > (1024*1024*128) order by registrationTime desc limit 15;"
```

From all packages currently in the store order by time they were registered, filter by 128MB size and show first 15 records.

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

## Issue: unsafe repository

```
sudo git config --global --add safe.directory /home/primamateria/dev/nixos
```

[Source](https://github.com/NixOS/nixpkgs/issues/169193)


## Check outputs of the flake

Useful when creating own flake and want to verify the outputs.

```
nix flake show
```

## Check definition nix expression

Good for quickly accessing "source code documentation".

```
nix edit nixpkgs#vimPlugins.nvim-treesitter.withPlugins
```

## Yueix init

```
cd /home/nixos
nix-shell -p git git-crypt neovim
# Download keychain
git clone https://github.com/PrimaMateria/nixos.git
git-crypt unlock ~/keychain/gitgpg.key
# Apply system
# Restart WSL, should boot to mbenko@yueix

sudo su
mv /home/nixos/nixos/ /home/nixos/keychain/ /home/mbenko/dev
chown -R mbenko keychain/
chown -R mbenko nixos/
exit

nix-shell -p git git-crypt neovim
git-crypt unlock ~/keychain/gitgpg.key
# fix resolv.conf again
./apply-users.sh

# Restart WSL again
# fix resolv.conf again
cd ~/dev/nixos
git remote remove origin
git remote add origin git@github.com:PrimaMateria/nixos.git
git branch --set-upstream-to=origin/master master

sudo rm -rf /home/nixos
```

## Starting vnc

```
xinit /home/mbenko/.vnc/xstartup -- $(realpath $(which Xvnc)) :1 PasswordFile=/home/mbenko/.vnc/passwd
```
