#!/bin/sh
# lutris-dmenu.sh: lutris dmenu script
#
# Copyright (c) 2022 Avalon Williams
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# requires: dmenu, lutris, sqlite3 command
# should work on *BSD but it hasn't been tested yet

run="${dmenu}/bin/dmenu -nb black -nf white -sb yellow -sf black -l 20 -c"

steamAppsPath=${XDG_DATA_HOME:-"$HOME/.local/share"}/Steam/steamapps
lutrisDatabase=${XDG_DATA_HOME:-"$HOME/.local/share"}/lutris/pga.db

if [ ! -e "$lutrisDatabase" ]; then
    echo "$0: lutris must have a game database before this script can be run" 1>&2
    exit 1
fi

steamGames() {
    for arg in "$steamAppsPath"/appmanifest_*.acf; do
      line=$(cat "$arg");
      nam="$(echo "$line"|tr '\n\t' ' '|sed 's/.*"name"[^"]*"\([^"]*\).*/\1/'|tr ' ' '_')"
      set -- "$@" "$nam" "$(echo "$line"|tr '\n\t' ' '|sed 's/.*"appid"[^"]*"\([^"]*\).*/\1/')" 
    done
    printf "Steam | %s | %s\n" "$@"
}

lutrisGames() {
    sqlite3 "$lutrisDatabase" 'SELECT id, name FROM games ORDER BY name' \
        | awk -F '|' '
            {
                w = length($1) > w ? length($1) : w
                l[i++] = $0
            }
            END {
                for (i in l) {
                    split(l[i], a)
                    printf 
                    # printf "Lutris | %s | %-*i\n", w, a[1], a[2]
                }
            }'
}

# if game=$(games | dmenu -i -l 10 -p 'Games' "$@"); then
#     # lutris "lutris:rungameid/${game%% *}"
#     echo "lutris:rungameid/${game%% *}"
# fi
#

steamGames
lutrisGames
