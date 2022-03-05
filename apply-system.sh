#!/bin/sh
pushd ~/dev/nixos
sudo nixos-rebuild switch --flake .#
popd

