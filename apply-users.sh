#!/bin/sh
pushd ~/dev/ws/nixos
home-manager switch -f ./users/primamateria/home.nix
popd
