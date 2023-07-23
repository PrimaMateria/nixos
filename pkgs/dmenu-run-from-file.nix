{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "dmenu-run-from-file";
  runtimeInputs = with pkgs; [ dmenu ];
  text = ''
    # Sligthly modified dmenu to provide also descriptions
    # Input argument is a file in following format:
    #    Description: Command
    #    Description: Command
    file=$1

    # Execute dmenu
    run="${pkgs.dmenu}/bin/dmenu -nb black -nf white -sb yellow -sf black -l 20 -c"
    selection=$($run < "$file" | awk -F ':' '{print $2}' )

    # Trim
    selection=$(echo "$selection" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

    # Execute selected program
    if [ -n "$selection" ]; then
      nohup "$selection" &
    fi
  '';
}

