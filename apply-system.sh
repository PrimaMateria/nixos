#!/bin/sh
pushd ~/dev/ws/nixos
sudo nixos-rebuild switch -I nixos-config=./system/configuration.nix
popd

