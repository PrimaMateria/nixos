inputs: prev: final:

{
  dmenu = inputs.dmenu-primamateria.packages.x86_64-linux.dmenu-primamateria;
  i3block-datetime = prev.callPackage ../pkgs/i3block-datetime.nix { };
  i3block-monitorManager = import ../pkgs/i3block-monitorManager.nix prev;
  i3blocks-contrib = import ../pkgs/i3blocks-contrib.nix prev final;
  i3blocks-gcalcli = inputs.i3blocks-gcalcli.packages.x86_64-linux.i3blocks-gcalcli;
  git-branch-clean = prev.callPackage ../pkgs/git-branch-clean.nix { };
  dmenu-run-from-file = import ../pkgs/dmenu-run-from-file.nix final;
  dmenu-run-steam = import ../pkgs/dmenu-run-steam.nix final;
  dmenu-i3-scratchpad = import ../pkgs/dmenu-i3-scratchpad.nix final;
}
