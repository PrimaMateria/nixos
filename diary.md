# Diary

## Sun Apr 24 06:02:27 PM CEST 2022

Preparing nix-shell for Arduino development environment. For Arduino management
I chose `arduino-cli`. Prepared config file also as separate derivation stored
in the store. Using trivial builder function `pkgs.writeTextFile`.

There is also simpler alternative `pkgs.writeText`. During start of nix-shell I
had issue that the content of the text file was evaluated. This was because I
have past the config derivation to the `buildInputs` of the shell, and it tried
to execute it as shell script.

## Sun Apr 24 10:12:40 PM CEST 2022

Learned about `pkgs.fetchurl` and `pkgs.fetchzip`. I was trying to download
https://github.com/witnessmenow/spotify-api-arduino and install it with
`arduino-cli`. Due to some errors, I (wrongly) assumed that the zip package must
have content of `src/`. I have followed example of `fetchzip` implementation and
wrote my own `postFetch` for the `fetchurl` where I have extracted the
downloaded zip file and create new archive which was placed in the store.

Unfortunately this was wrong move, because the Arduino [Library
Specification](https://arduino.github.io/arduino-cli/0.19/library-specification/)
requires such hierarchy as in GitHub repo. Probably there was naming mismatch
between the repository name and file names. Will continue next time.

## Mon Apr 25 06:15:54 PM CEST 2022

Starting to work on NixOS for WSL. Used code-name "yueix" from doctor Yue who
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
and feels bit hacky. Subscribed to the GitHub issue to see if some more proper
solution will appear.

## Wed Apr 27 02:06:35 AM CEST 2022

I started preparing the environment for web development. I have installed
missing neovim plugins and copied the typescript LSP server configuration.
Furthermore, I have encountered issue with `cmp-nvim-ultisnips` plugin. Even I
have found it in `nixpkgs` (`nix search nixpgs cmp-nvim-ultisnips`), the build
keep complaining that this is unknown variable. Flake input update didn't help
as well.

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
is present. Btw, it seems that the non-slim version is deprecated, so I should
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

## Wed May 4 11:01:24 AM CEST 2022

Following [tutorial by Justin
Restivo](https://justin.restivo.me/posts/2021-10-24-neovim-nix.html) I was able
to create neovim flake in standalone repository. It's based on official neovim
flake which can be obtained from any revision, so updating to nightly builds is
now no problem to do. Plugins and config is already baked in my custom neovim
flake. I didn't finish setting up cachix account. This custom flake should be
also possible to run with nix-portable, so I could theoretically try it before
switching to yueix.

During the work I have again made mistake of how I referred to package obtained
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

## Sat May 28 03:28:46 PM CEST 2022

Another try to set up yueix. Used new WSL image which was recently released and
uses NixOS 21. Created 2 new shells, one for React development and other for
Java.

Had an issue with windows Docker Desktop. With turned on WSL integration
option, Docker Desktop always failed with message that process starting it for
NixOS returned exit code 1. Found GitHub issue [Docker Desktop WSL2 not
working](https://github.com/nix-community/NixOS-WSL/issues/89). I observed the
same difference in the paths. But even so, the command with correct path failed
to start docker with various errors. Sometimes also happened, that the
`/mnt/wsl/docker-desktop/docker-desktop-user-distro` had 0 bytes and couldn't
be executed. Problems were inconsistent, and I found other threads reporting the
same issue with different distros, and with fixes in the sense of try to
restart and reinstall everything and pray it will help. Therefore, I decided to
try if Docker running natively in NixOS would work. Fortunately it was
successful just with one small workaround to enable legacy iptables for the
docker which I found in issue [native docker
support](https://github.com/nix-community/NixOS-WSL/issues/59).

Last thing that helped was that I found in some other configs on GitHub that it
is possible to instruct WSL to use specific hostname. This another option from
usual `networking.hostname`. Added to `wslConf.network` `hostname` and
`generateResolvConf` set to false. The proper hostname solves the issue with no
working `apply-system.sh`.

## Sun May 29 02:01:33 PM CEST 2022

I was dealing with the trouble of setting up VNC, so I can use IntelliJ IDEA if
necessary. First I tried simply to copy xserver config from tprobix, but
`journalctl` reported that it fails to start xserver. After I switched from i3
to Xfce and enabled `gdm` displayManager the server could start. For now, it is
enough to have any working solution, but there is plenty space for experiments.
Also, I could investigate some light alternatives to Xfce. I came across IceWM,
but didn't go into the details.

Second problem occurred when I tried to start VNC server. I added `tigervnc`
package, but executing the vncserver failed because of missing `xinit`. With
`xorg.init` package added, it failed with message that `XSession` is missing. I
followed [this
comment](https://github.com/NixOS/nixpkgs/issues/109500#issuecomment-901990922)
and was able to start the server. I wrote own `.vnc/xstartup` and generate
password file with `vncpassword` command. When `xstartup` runs session in the
background, then xinit stops with message `xinit; connection to X server lost`.
If session is run in the foreground then it is possible to connect with the
vncviewer. I still need to include `~/.vnc` to nixos repo.

## Tue May 31 12:20:34 PM CEST 2022

I found out that I forgot about `eslint_d` and `prettierd`. For the quick fix
it was enough to install them as global npm package. Although this is not
reproducible. I came across [github
repos](https://github.com/stellarhoof/furnisher/tree/c27cb169ea915c5e4fe6b32e64ba07b4d6d2d9c7/users/shared/programs/nvim/node-packages)
where they used `node2nix` to generate missing nix package. Then through
overlay it could be installed. This could be useful also for future. Adding it
to the to-do list.

## Tue May 31 03:42:54 PM CEST 2022

I was migrating UltiSnips snippets to neovim-nix. I added new package to the
overlay definition. The package is made with `stdenv.mkDerivation` which source
local directory and during the installation phase simply copies all directory
content to the `$out`. Then I added this package as a runtime dependency for
customNeovim. As last, I passed the package as argument to `import` call. I had
to pass it down to ultisnips config where I set the nix store path as the
UltiSnips snippet directory. Passing the vars like that didn't look very
elegant, but for now it just works.

## Tue Jun 7 10:46:19 AM CEST 2022

I have prepared watson-jira as a flake. Now I am thinking if I could expose
also it's config as nix options. The way somehow leads to nixos modules. The
same modules should work also with Home Manager. One option would be somehow to
write the config file to user's XDG_CONFIG_HOME. Other option may be to update
watson-jira to be able to read config location from the parameter and then
generate config file during the build in the nix store out directory.

## Sat Oct 1 12:48:38 PM CEST 2022

Runtime dependencies are build dependencies that are later found in result.
Patchelf is a tool which helps to deal with unecessary dependency listing in
some kind of path when compiling C programs.

Wrapper pattern is useful if it is needed to include runtime dependencies to
program that doesn't requires them to work. In wrapper pattern a simple shell
script derivation can be prepared `writeShellApplication` which adds extra
runtime dependencies to the `PATH` and executes the real program. For example, I
used this when adding `xsel`, or `typescript-language-server` to be available
for neovim. Then instead of declaring neovim as a program in Home Manager, I
declared the my neovim wrapper. Extra runtime dependencies can be collected
into one derivation using `symlinkJoin`.

## Sun Oct 23 10:07:44 PM CEST 2022

I found an enhancement to previously mentioned wrapper pattern. The wrapper
script should pass all the args to the target app. Also, I had `nvim` aliased
to `nix run ~/dev/neovim-nix/`. Adding any args would apply to `nix` command.
Changing alias to `nix run ~/dev/neovim-nix --` passes all the args directly to
the target neovim executable.

## Fri Dec 16 04:51:08 PM CET 2022

During the work on neovim-nix I learned few interesting things. `nix build -L`
is very useful during the debugging of build of derivation. During the build
there is no internet connection, so if there are prerequisites, they need to be
first fetched, packaged and provided to build inputs via nix.
