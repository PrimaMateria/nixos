# __/\\\\\\\\\\\_____/\\\\\\\\\\__        
#  _\/////\\\///____/\\\///////\\\_       
#   _____\/\\\______\///______/\\\__      
#    _____\/\\\_____________/\\\//___     
#     _____\/\\\____________\////\\\__    
#      _____\/\\\_______________\//\\\_   
#       _____\/\\\______/\\\______/\\\__  
#        __/\\\\\\\\\\\_\///\\\\\\\\\/___ 
#         _\///////////____\/////////_____

{pkgs, config, lib, dmenu-primamateria, i3blocks-gcalcli, ...}:
let
  i3wsrConfig = pkgs.copyPathToStore ../configs/i3wsr.toml;
  dmenu = dmenu-primamateria.packages.x86_64-linux.dmenu-primamateria;
  i3blocks-gcalcli-package = i3blocks-gcalcli.packages.x86_64-linux.i3blocks-gcalcli;
  i3blocksSecrets = import ../.secrets/i3blocks.nix;
  i3blocksConfig = pkgs.writeText "i3blocks-config" ''
    separator_block_width=20
    markup=none

    [kbdd_layout]
    command=${pkgs.i3blocks-contrib.kbdd_layout}/libexec/i3blocks/kbdd_layout
    interval=persist

    [volume-pulseaudio]
    command=${pkgs.i3blocks-contrib.volume-pulseaudio}/libexec/i3blocks/volume-pulseaudio -H "" -M "" -L "" -X ""
    interval=once
    signal=1
    LONG_FORMAT="''${VOL}% [''${NAME}]"
    SHORT_FORMAT="''${VOL}% [''${INDEX}]"
    DEFAULT_COLOR=#FFFFFF
    
    [gcalcli]
    command=${i3blocks-gcalcli-package}/bin/i3blocks-gcalcli -e "matus.benko@gmail.com" -m "matus.benko@gmail.com" -m "Holidays in Germany" -m "Sviatky na Slovensku" -w 20 --clientId ${i3blocksSecrets.gcalcliClientId} --clientSecret ${i3blocksSecrets.gcalcliClientSecret} -f "CaskaydiaCove Nerd Font Mono"
    interval=1800

    [datetime]
    command="i3block-datetime"
    interval=1
  '';

  scratchpadShow = pkgs.writeShellApplication {
    name = "scratchpadShow";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      i3-msg -t get_tree | \
      jq '.nodes[] | .nodes[] | .nodes[] | select(.name=="__i3_scratch") | .floating_nodes[] | .nodes[] | .window,.name' | \
      sed 's/\"//g' | \
      paste - - -d ' ' | \
      ${dmenu}/bin/dmenu -nb black -nf white -sb yellow -sf black -l 20 -c | \
      cut -f1 -d ' '| \
      xargs -I "PID" i3-msg "[id=PID] scratchpad show"
     '';
  };

  steamRun = pkgs.writeShellApplication {
    name = "steamRun";
    text = ''
      run="${dmenu}/bin/dmenu -nb black -nf white -sb yellow -sf black -l 20 -c"
      path="$HOME/.local/share/Steam/steamapps"

      for arg in "$path"/appmanifest_*.acf; do
        line=$(cat "$arg");
        nam="$(echo "$line"|tr '\n\t' ' '|sed 's/.*"name"[^"]*"\([^"]*\).*/\1/'|tr ' ' '_')"
        set -- "$@" "$nam" "$(echo "$line"|tr '\n\t' ' '|sed 's/.*"appid"[^"]*"\([^"]*\).*/\1/')" 
      done

      run=$(printf "%s  :%s\n" "$@" | $run | sed 's/.*:\(.*\)/\1/')
      test -n "$run" && xdg-open "steam://run/$run"
    '';
  };
in
{

  xsession.enable = true;
  xsession.initExtra = ''
    xrandr --output DP-2 --mode 2560x1440 --rate 143.86 --primary
  '';

  services.picom = {
    enable = true;
    backend = "xrender";
    vSync = true;
    extraOptions = ''
      unredir-if-possible = false;
    '';
  };

  services.blueman-applet.enable = true;

  xsession.windowManager.i3 = {
    enable = true;
    config = let
      mod = "Mod4";
      alt = "Mod1";

      colorDominant = "#FFFFFF";
      colorProminent = "#FFFF00";
      colorDrab = "#464646";
      colorBackground = "#000000";
      colorAlert = "#FF0000";

      workspaces = ["0:" "1:" "2:" "3:" "4:" "5:" "6:" "7:" "8:" "9:"];
      ws = n: builtins.elemAt workspaces n;

      cmdMenu = "${dmenu}/bin/dmenu_run -nb black -nf white -sb yellow -sf black -l 20 -c";
      cmdBrowser = "firefox";
      cmdTerminal = "alacritty";

      modeSystem = "System (e) logout, (s) suspend, (r) reboot, (Shift+s) shutdown";
      modeResize = "Resize";
    in {
      modifier = mod;
      fonts = {
        names = ["CaskaydiaCove Nerd Font Mono"];
        size = 10.0;
      };
      colors = {
        background = "${colorBackground}";
        focused = {
          border      = "${colorDominant}";
          childBorder = "${colorDominant}";
          background  = "${colorBackground}";
          text        = "${colorProminent}";
          indicator   = "${colorDominant}";
        };
        focusedInactive = {
          border      = "${colorDrab}";
          childBorder = "${colorDrab}";
          background  = "${colorBackground}";
          text        = "${colorProminent}";
          indicator   = "${colorDominant}";
        };
        unfocused = {
          border      = "${colorDrab}";
          childBorder = "${colorDrab}";
          background  = "${colorBackground}";
          text        = "${colorDominant}";
          indicator   = "${colorDrab}";
        };
        urgent = {
          border      = "${colorAlert}";
          childBorder = "${colorAlert}";
          background  = "${colorBackground}";
          text        = "${colorDominant}";
          indicator   = "${colorAlert}";
        };
        placeholder = {
          border      = "${colorDrab}";
          childBorder = "${colorProminent}";
          background  = "${colorBackground}";
          text        = "${colorDominant}";
          indicator   = "${colorDominant}";
        };
      };
      keybindings = {
        "${mod}+q" = "kill";
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+r" = "restart";
        "${mod}+f" = "fullscreen toggle";
        "${mod}+Shift+space" = "floating toggle";

        "${mod}+d" = "exec --no-startup-id ${cmdMenu}";
        "${mod}+s" = "exec --no-startup-id ${steamRun}/bin/steamRun";
        "${mod}+Shift+Return" = "exec ${cmdBrowser}";
        "${mod}+Return" = "exec ${cmdTerminal}";

        "${mod}+r" = "mode ${modeResize}";
        "${mod}+Shift+e" = "mode \"${modeSystem}\"";
      
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";
        "${mod}+a" = "focus parent";
        "${mod}+z" = "focus child";
        "${alt}+Tab" = "focus next";
        "${alt}+Shift+Tab" = "focus next sibling";
        "${mod}+space" = "focus mode_toggle";

        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        "${mod}+F2" = "layout tabbed";
        "${mod}+F3" = "layout splith";
        "${mod}+F4" = "layout splitv";
        "${mod}+F5" = "layout stacked";
        "${mod}+F6" = "split horizontal, layout stacking";

        "${mod}+BackSpace" = "workspace back_and_forth";
        "${mod}+0" = "workspace number ${ws 0}";
        "${mod}+1" = "workspace number ${ws 1}";
        "${mod}+2" = "workspace number ${ws 2}";
        "${mod}+3" = "workspace number ${ws 3}";
        "${mod}+4" = "workspace number ${ws 4}";
        "${mod}+5" = "workspace number ${ws 5}";
        "${mod}+6" = "workspace number ${ws 6}";
        "${mod}+7" = "workspace number ${ws 7}";
        "${mod}+8" = "workspace number ${ws 8}";
        "${mod}+9" = "workspace number ${ws 9}";

        "${mod}+Shift+0" = "move container to workspace number ${ws 0}";
        "${mod}+Shift+1" = "move container to workspace number ${ws 1}";
        "${mod}+Shift+2" = "move container to workspace number ${ws 2}";
        "${mod}+Shift+3" = "move container to workspace number ${ws 3}";
        "${mod}+Shift+4" = "move container to workspace number ${ws 4}";
        "${mod}+Shift+5" = "move container to workspace number ${ws 5}";
        "${mod}+Shift+6" = "move container to workspace number ${ws 6}";
        "${mod}+Shift+7" = "move container to workspace number ${ws 7}";
        "${mod}+Shift+8" = "move container to workspace number ${ws 8}";
        "${mod}+Shift+9" = "move container to workspace number ${ws 9}";

        "${mod}+x" = "move scratchpad";
        "${mod}+Shift+x" = "exec ${scratchpadShow}/bin/scratchpadShow";

        "${mod}+minus" = "[class=\"Enpass\" title=\"^Enpass$\"] scratchpad show";
      };

      modes = {
        "${modeResize}" = {
          h = "resize shrink width 10 px or 10 ppt";
          j = "resize grow height 10 px or 10 ppt";
          k = "resize shrink height 10 px or 10 ppt";
          l = "resize grow width 10 px or 10 ppt";
          Escape = "mode default";
        };
        "${modeSystem}" = {
          "Shift+s" = "exec --no-startup-id systemctl poweroff -i, mode default";
          e = "exec --no-startup-id i3-msg exit, mode default";
          s = "exec --no-startup-id systemctl suspend, mode default";
          r = "exec --no-startup-id systemctl reboot, mode default";
          Escape = "mode default";
        };
      };

      bars = [
        {
          statusCommand = "i3blocks -c ${i3blocksConfig}";
          position = "top";
          fonts = {
            size = 10.0;
          };
          colors = {
            background = "${colorBackground}";
            statusline = "${colorDominant}";
            separator = "${colorDrab}";
            focusedWorkspace = {
              border = "${colorBackground}";
              background = "${colorBackground}";
              text = "${colorProminent}";
            };
            activeWorkspace = {
              border = "${colorBackground}";
              background = "${colorBackground}";
              text = "${colorProminent}";
            };
            inactiveWorkspace = {
              border = "${colorBackground}";
              background = "${colorBackground}";
              text = "${colorDominant}";
            };
            urgentWorkspace = {
              border = "${colorBackground}";
              background = "${colorBackground}";
              text = "${colorAlert}";
            };
            bindingMode = {
              border = "${colorBackground}";
              background = "${colorProminent}";
              text = "${colorBackground}";
            };
          };
        }
      ];

      workspaceLayout = "tabbed";
      defaultWorkspace = "workspace ${ws 1}";

      floating = {
        modifier = mod;
        border = 1;
        titlebar = true;
      };

      focus = {
        followMouse = false;
      };

      window = {
        hideEdgeBorders = "none";
        commands = [
          # Enpass
          {
            criteria = { class = "Enpass"; title = "^Enpass$"; };
            command = "floating enable";
          }
          {
            criteria = { class = "Enpass"; title = "^Enpass$"; };
            command = "resize set 800 520";
          }
          {
            criteria = { class = "Enpass"; title = "^Enpass$"; };
            command = "move absolute position 1678 918";
          }
          {
            criteria = { class = "Enpass"; title = "^Enpass$"; };
            command = "move scratchpad";
          }

          # i3blocks-gcalcli
          {
            criteria = { class = "XTerm"; title = "i3blocks-gcalcli"; };
            command = "floating enable";
          }
          {
            criteria = { class = "XTerm"; title = "i3blocks-gcalcli"; };
            command = "border none";
          }
          {
            criteria = { class = "XTerm"; title = "i3blocks-gcalcli"; };
            command = "move position center";
          }
        ];
      };

      startup = [
        { command = "Enpass"; notification = false; }
        { command = "${pkgs.i3wsr}/bin/i3wsr --config ${i3wsrConfig}"; notification = false; }
        { command = "hsetroot -solid \"#111111\""; notification = false; }
        { command = "i3-msg workspace '${ws 1}'"; notification = false; }
      ];
    };
    extraConfig = ''
      title_align center
      default_border normal
    '';
  };

  home.packages = [
    dmenu
    i3blocks-gcalcli-package
    pkgs.i3blocks
    pkgs.hsetroot
    pkgs.i3block-datetime
    pkgs.i3wsr
    pkgs.i3blocks-contrib.volume-pulseaudio
    pkgs.i3blocks-contrib.kbdd_layout
  ];
}
