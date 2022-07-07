{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let 
  workSecrets = import .secrets/work.nix;
  gradle_7_jdk11 = gradle_7.overrideAttrs (oldAttrs: rec {
    defaultJava = jdk11;
  });
in
mkShell {
  name = "java-shell";
  buildInputs = [
    jdk11
    gradle_7_jdk11
  ];
  shellHook = ''
    export JAVA_HOME="${jdk11.home}"
    export ORG_GRADLE_PROJECT_FINAPI_ARTIFACTORY_USER=${workSecrets.artifactoryUser}
    export ORG_GRADLE_PROJECT_FINAPI_ARTIFACTORY_TOKEN=${workSecrets.artifactoryToken}
    alias gradle="gradle ${workSecrets.gradleProperties} -Dorg.gradle.java.home=${jdk11}/lib/openjdk --no-watch-fs"
  '';
}
