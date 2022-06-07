{ config, pkgs, watson-jira-next, ... }:

let
  package-watson-jira-next = watson-jira-next.defaultPackage.x86_64-linux;
in
{
  home.packages = [
    package-watson-jira-next
  ];
  xdg.configFile."watson-jira/config.yaml".source = ../.secrets/watson-jira/config.yaml;
}
