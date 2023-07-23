{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "dmenu";
  runtimeInputs = with pkgs; [ dmenu ];
  text = ''
    run="${pkgs.dmenu}/bin/dmenu -nb black -nf white -sb yellow -sf black -l 20 -c"
    path="$HOME/.local/share/Steam/steamapps"

    for arg in "$path"/appmanifest_*.acf; do
      line=$(cat "$arg");
      nam="$(echo "$line"|tr '\n\t' ' '|sed 's/.*"name"[^"]*"\([^"]*\).*/\1/'|tr ' ' '_')"
      set -- "$@" "$nam" "$(echo "$line"|tr '\n\t' ' '|sed 's/.*"appid"[^"]*"\([^"]*\).*/\1/')" 
    done

    run=$(printf "%s  :%s\n" "$@" | $run | sed 's/.*:\(.*\)/\1/')
    test -n "$run" && xdg-open "steam://run/$run"
  '';
}

