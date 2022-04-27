# Diary

## Sun Apr 24 06:02:27 PM CEST 2022

Preparing nix-shell for arduino development environment. For arduino management
I chose `arduino-cli`. Prepared config file also as separate derivation stored
in the store. Using trivial builder function `pkgs.writeTextFile`.

There is also simpler alternative `pkgs.writeText`. During start of nix-shell I
had issue that the content of the text file was evaluated. This was because I
have past the config derivation to the `buildInputs` of the shell, and it tried
to execute it as shell script.

## Sun Apr 24 10:12:40 PM CEST 2022

Learned about `pkgs.fetchurl` and `pkgs.fetchzip`. I was trying to download
https://github.com/witnessmenow/spotify-api-arduino and install it with
`arduino-cli`. Due some errors, I (wrongly) assumed that the zip package must
have content of `src/`. I have follow example of `fetchzip` implementation and
wrote my own `postFetch` for the `fetchurl` where I have extracted the
downloaded zip file and create new archive which was placed in the store.

Unfortunately this was wrong move, because the Arduino [Library
Specification](https://arduino.github.io/arduino-cli/0.19/library-specification/)
requires such hierarchy as in github repo. Probably there was naming mismatch
between the repository name and file names. Will continue next time.

## Mon Apr 25 06:15:54 PM CEST 2022

Starting to work on NixOS for WSL. Used codename "yueix" from doctor Yue who
was a traitor to Duke Leto. A forced traitor by hard life circumstances. Good
name for Linux instance running in Microsoft's WSL. For the beginning starting
with pure shell environment. So far most of the things work.

## Mon Apr 25 10:29:42 PM CEST 2022

Introduce better organization of the modules after adding "yueix" and "mbenko".
Encountered error message from git about "unsafe repository". Caused by running
`./apply-system.sh` as sudo. `nixos-rebuild` using flakes executes git command
as root on repository which is owned by other user and thus this message. This
is caused by new recent git version. Fixed the issue by adding exception for
the repository directory to the git config of the root. This is manual action
and feels bit hacky. Subscribed to the github issue to see if some more proper
solution will appear.

## Wed Apr 27 02:06:35 AM CEST 2022

I started preparing the environment for web development. I have installed
missing neovim plugins and copied the typescript LSP server configuration. I
have encountered issue with `cmp-nvim-ultisnips` plugin. Even I have found it
in `nixpkgs` (`nix search nixpgs cmp-nvim-ultisnips`), the build keep
complaining that this is unknown variable. Flake input update didn't help as
well.

Something new unexpected was, that on NixOS `npm install --global` doesn't work
out of the box. `npm` must be configured to store global packages in home
folder (by default it tries to store them in derivation in nix store). Or,
better way is to get it from nixpkgs from the `nodePackages` namespace.
Although, it didn't seem to have many npm packages migrated over, but I was
lucky that `typescript-language-server` was present.

One more unsolved issue is that `null-ls` server is not started. I need to
crosscheck it with kali and check if I have all required config migrated to nix
files.
