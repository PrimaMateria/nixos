{ lib, python, python3 }:

let
  td-watson = python3.pkgs.buildPythonPackage rec {
    pname = "td-watson";
    version = "2.1.0";
    src = python3.pkgs.fetchPypi {
      inherit pname version;
    };
    doCheck = false;
  };
in
python3.pkgs.buildPythonApplication rec {
  pname = "watson-jira-next";
  version = "0.3.2";
  format = "wheel";

  src = python3.pkgs.fetchPypi rec {
    inherit pname version format;
    sha256 = "";
    dist = python3;
    python = "py3";
  };

  propagatedBuildInputs = [
    td-watson
    python3.pkgs.python-dateutil
    python3.pkgs.click
    python3.pkgs.simplejson
    python3.pkgs.colorama
    python3.pkgs.jira
    python3.pkgs.pyyaml
    python3.pkgs.pyxdg
  ];
}
