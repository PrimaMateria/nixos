#!/bin/sh
pushd ~/dev/ws/nixos
nix build .#homeManagerConfigurations.primamateria.activationPackage
./result/activate
popd
