{ config, pkgs, pkgs-unstable, ... }:
let
  vncXstartup = pkgs.writeShellApplication {
    name = "xstartup";
    text = ''
      icewm
    '';
  };

  vncPasswd = pkgs.writeTextFile {
    name = "vnc-passwd";
    text = import ../.secrets/vnc/passwd.nix;
  };
in
{
  # vnc itself is installed on system level

  programs.bash.shellAliases = {
    runx = "xinit ${vncXstartup}/bin/xstartup -- $(realpath $(which Xvnc)) :1 PasswordFile=${vncPasswd}";
  };
}
   
