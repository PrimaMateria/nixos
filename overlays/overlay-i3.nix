final: prev: 

{
  i3block-datetime = prev.callPackage ../pkgs/i3block-datetime.nix { };
  i3blocks-contrib = import ../pkgs/i3blocks-contrib.nix final prev;
  # TODO: extract from this overlay or rename it to something generic
  # watson-jira-next = prev.callPackage ../pkgs/watson-jira-next.nix { };
}
