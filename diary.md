# Diary

## Sun Apr 24 06:02:27 PM CEST 2022

Preparing nix-shell for arduino development environment. For arduino management
I chose `arduino-cli`. Prepared config file also as separate derivation stored
in the store. Using trivial builder function `pkgs.writeTextFile`.

There is also simpler alternative `pkgs.writeText`. During start of nix-shell I
had issue that the content of the text file was evaluated. This was because I
have past the config derivation to the `buildInputs` of the shell, and it tried
to execute it as shell script.

## Sun Apr 24 10:12:40 PM CEST 2022

Learned about `pkgs.fetchurl` and `pkgs.fetchzip`. I was trying to download
https://github.com/witnessmenow/spotify-api-arduino and install it with
`arduino-cli`. Due some errors, I (wrongly) assumed that the zip package must
have content of `src/`. I have follow example of `fetchzip` implementation and
wrote my own `postFetch` for the `fetchurl` where I have extracted the
downloaded zip file and create new archive which was placed in the store.

Unfortunately this was wrong move, because the Arduino [Library
Specification](https://arduino.github.io/arduino-cli/0.19/library-specification/)
requires such hierarchy as in github repo. Probably there was naming mismatch
between the repository name and file names. Will continue next time.
