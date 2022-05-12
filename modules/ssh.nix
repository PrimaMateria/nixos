{ config, pkgs, ... }:

let
  identityFileGithub = pkgs.copyPathToStore ../.secrets/ssh-keys/github.com;
  identityFileGitlab = pkgs.copyPathToStore ../.secrets/ssh-keys/gitlab.com;
  identityFileBitbucket = pkgs.copyPathToStore ../.secrets/ssh-keys/bitbucket.org;
in
{
  programs.ssh = {
    enable = true;
    hashKnownHosts = true;
    matchBlocks = {
      "github.com" = {
        host = "github.com";
        identityFile = "${identityFileGithub}";
      };
      "gitlab.com" = {
        host = "gitlab.com";
        identityFile = "${identityFileGitlab}";
      };
      "bitbucket.org" = {
        host = "bitbucket.org";
        identityFile = "${identityFileBitbucket}";
      };
    };
  };
}
