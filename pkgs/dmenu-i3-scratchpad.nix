{ pkgs, ... }:

pkgs.writeShellApplication {
    name = "dmenu";
    runtimeInputs = with pkgs; [ dmenu jq ];
    text = ''
      i3-msg -t get_tree | \
      jq '.nodes[] | .nodes[] | .nodes[] | select(.name=="__i3_scratch") | .floating_nodes[] | .nodes[] | .window,.name' | \
      sed 's/\"//g' | \
      paste - - -d ' ' | \
      ${pkgs.dmenu}/bin/dmenu -nb black -nf white -sb yellow -sf black -l 20 -c | \
      cut -f1 -d ' '| \
      xargs -I "PID" i3-msg "[id=PID] scratchpad show"
    '';
}

