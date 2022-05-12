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

## Thu Apr 28 11:01:13 AM CEST 2022

I have find out that `null-ls` was missing `eslint_d` and `prettier_d`.
`eslint_d` was found in nodePackages, but nor `prettier_d` or `prettier_d_slim`
is present.  Btw, it seems that the non-slim version is deprecated, so I should
switch. The plan is to ask on IRC for help how to create and submit new
  nodePackage to nix channel. These are generated nix definitions, probably
  using `node2nix` tool. I should try it, compare the results.

## Fri Apr 29 01:48:05 AM CEST 2022

I investigated problems with `null-ls`. The error was that in nvim lua
configuration I tried to call function `require('null-ls').setup()` which
didn't exist. This is because the plugin's nix package is frozen on specific
commit from a year ago, and that time `null-ls` used function `config` instead
of `setup`. Now I have two options: rewrite nvim config to use old version, or
make own package with latest version. 

## Sat Apr 30 01:10:50 PM CEST 2022

Regarding the issue with outdated `null-ls` I got some ideas what to
investigate further. First is about nix channel, maybe because I am using
stable channel it is expected from packages to be frozen at some point in the
time. I should see what's the status on the unstable channel. Second idea was
to override the package source commit and hash. And the last one is to build
derivation directly from github.

## Wed May  4 11:01:24 AM CEST 2022

Following [tutorial by Justin
Restivo](https://justin.restivo.me/posts/2021-10-24-neovim-nix.html) I was able
to create neovim flake in standalone repository. It's based on official neovim
flake which can be obtained from any revision, so updating to nightly builds is
now no problem to do. Plugins and config is already baked in my custom neovim
flake. I didn't finish setting up cachix account. This custom flake should be
also runnable with nix-portable, so I could theoretically try it before
switching to yueix.

During the work I have again make mistake of how I referred to package obtained
as a flake input. I need to use the full path:
`neovim-primamateria.packages.x86_64-linux.customNeovim`. This issue was
causing [very unclear
error](https://github.com/nix-community/home-manager/issues/2409) thrown by
Home Manager.

```
bug: error: 'builtins.storePath' is not allowed in pure evaluation mode
```

## Fri May 13 12:28:48 AM CEST 2022

During the configuration of ssh I have decided to reuse the same keys for
multiple machines/users.

