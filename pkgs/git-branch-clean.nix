{ writeShellApplication }:
writeShellApplication {
  name = "git-branch-clean";
  text = ''
    if [[ $* == *--dry* ]]; then
      git branch |\
      grep -v "develop\|main\|master" |\
      sed "s/  //" |\
      xargs -I {} echo "Will delete {}"
    else
      git branch |\
      grep -v "develop\|main\|master" |\
      sed "s/  //" |\
      xargs -I {} git branch -D {}
    fi
  '';
}
