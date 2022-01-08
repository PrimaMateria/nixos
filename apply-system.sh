#!/bin/sh
pushd ~/dev/ws/nixos
sudo nixos-rebuild switch --flake .#
popd

