inputs: prev: final:

{
  dmenu = inputs.dmenu-primamateria.packages.x86_64-linux.dmenu-primamateria;
  i3block-datetime = prev.callPackage ../pkgs/i3block-datetime.nix { };
  i3blocks-contrib = import ../pkgs/i3blocks-contrib.nix prev final;
  git-branch-clean = prev.callPackage ../pkgs/git-branch-clean.nix { };
  i3block-monitorManager = import ../pkgs/i3block-monitorManager.nix prev;
  dmenu-run-from-file = import ../pkgs/dmenu-run-from-file.nix final;
}
