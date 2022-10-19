final: prev: 

{
  i3block-datetime = prev.callPackage ../pkgs/i3block-datetime.nix { };
  i3blocks-contrib = import ../pkgs/i3blocks-contrib.nix final prev;
  git-branch-clean = prev.callPackage ../pkgs/git-branch-clean.nix { };
}
