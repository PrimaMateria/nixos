final: prev:

{
  i3block-datetime = prev.callPackage ../pkgs/i3block-datetime.nix { };
  i3blocks-contrib = import ../pkgs/i3blocks-contrib.nix final prev;
  git-branch-clean = prev.callPackage ../pkgs/git-branch-clean.nix { };
  i3block-monitorManager = import ../pkgs/i3block-monitorManager.nix final;
}
