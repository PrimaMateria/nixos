#!/bin/sh
pushd ~/dev/nixos
nix build .#homeManagerConfigurations.primamateria.activationPackage
./result/activate
popd
