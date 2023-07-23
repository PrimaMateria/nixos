#!/bin/sh
clear
nix build .#homeManagerConfigurations.${USER}.activationPackage
./result/activate
