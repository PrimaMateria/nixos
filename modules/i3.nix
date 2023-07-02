# __/\\\\\\\\\\\_____/\\\\\\\\\\__        
#  _\/////\\\///____/\\\///////\\\_       
#   _____\/\\\______\///______/\\\__      
#    _____\/\\\_____________/\\\//___     
#     _____\/\\\____________\////\\\__    
#      _____\/\\\_______________\//\\\_   
#       _____\/\\\______/\\\______/\\\__  
#        __/\\\\\\\\\\\_\///\\\\\\\\\/___ 
#         _\///////////____\/////////_____

{ pkgs, pkgs-unstable, config, lib, dmenu-primamateria, i3blocks-gcalcli, ... }:
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
    DEFAULT_COLOR=#FBF1C7
    
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

  startCmus = pkgs.writeShellApplication {
    name = "startCmus";
    text = ''
      cd "$HOME/Music/ambients"
      cmus
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
    # vSync = true;
    shadow = true;
    shadowExclude = [
      "window_type *= 'menu'"
      "class_g = 'i3bar'"
    ];
    settings = {
      unredir-if-possible = false;
      shadow-color = "#FFFFFF";
      shadow-radius = 30;
      shadow-offset-x = -30;
      shadow-offset-y = -30;
      shadow-opacity = 0.3;
      shadow-ignore-shaped = true;
    };
  };

  services.blueman-applet.enable = true;

  home.file.solarSystem = {
    source = ../configs/solarSystem;
    target = ".config/i3/wallpapers";
  };

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs-unstable.i3;
    config =
      let
        mod = "Mod1"; #Mod4

        colorDominant = "#FBF1C7";
        colorProminent = "#FABD2F";
        colorDrab = "#464646";
        colorBackground = "#000000";
        colorBackgroundBar = "#303030";
        colorAlert = "#FF0000";

        workspaces = [ "10: Messier 87" "1: Sun" "2: Mercury" "3: Venus" "4: Earth" "5: Mars" "6: Jupiter" "7: Saturn" "8: Chat" "9: Music" ];
        ws = n: builtins.elemAt workspaces n;

        wallpapers = [ "messier87.jpg" "sun.jpg" "mercury.jpg" "venus.jpg" "earth.jpg" "mars.jpg" "jupiter.jpg" "saturn.jpg" "uranus.jpg" "neptune.jpg" ];
        wswall = n: builtins.elemAt wallpapers n;

        setWallpaper = w: "exec --no-startup-id feh --bg-center ~/.config/i3/wallpapers/${w}";


        cmdMenu = "${dmenu}/bin/dmenu_run -nb black -nf white -sb yellow -sf black -l 20 -c";
        cmdBrowser = "firefox -P default";
        cmdTerminal = "alacritty";

        modeSystem = "System (e) logout, (s) suspend, (r) reboot, (Shift+s) shutdown";
        modeResize = "Resize";
      in
      {
        modifier = mod;
        fonts = {
          names = [ "CaskaydiaCove Nerd Font Mono" ];
          size = 10.0;
        };

        gaps = {
          inner = 25;
        };

        colors = {
          background = "${colorBackground}";
          focused = {
            border = "${colorDrab}";
            childBorder = "${colorDrab}";
            background = "${colorBackground}";
            text = "${colorProminent}";
            indicator = "${colorDrab}";
          };
          focusedInactive = {
            border = "${colorDrab}";
            childBorder = "${colorDrab}";
            background = "${colorBackground}";
            text = "${colorProminent}";
            indicator = "${colorDominant}";
          };
          unfocused = {
            border = "${colorDrab}";
            childBorder = "${colorDrab}";
            background = "${colorBackground}";
            text = "${colorDominant}";
            indicator = "${colorDrab}";
          };
          urgent = {
            border = "${colorAlert}";
            childBorder = "${colorAlert}";
            background = "${colorBackground}";
            text = "${colorDominant}";
            indicator = "${colorAlert}";
          };
          placeholder = {
            border = "${colorDrab}";
            childBorder = "${colorProminent}";
            background = "${colorBackground}";
            text = "${colorDominant}";
            indicator = "${colorDominant}";
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
          "${mod}+Tab" = "focus next";
          "${mod}+Shift+Tab" = "focus previous";
          "${mod}+space" = "focus mode_toggle";

          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";

          "${mod}+m" = "layout tabbed";
          "${mod}+t" = "layout splith";
          "${mod}+F4" = "layout splitv";
          "${mod}+F5" = "layout stacked";
          "${mod}+F6" = "split horizontal, layout stacking";

          "${mod}+BackSpace" = "workspace back_and_forth";
          "${mod}+1" = "workspace number ${ws 1}";
          "${mod}+2" = "workspace number ${ws 2}";
          "${mod}+3" = "workspace number ${ws 3}";
          "${mod}+4" = "workspace number ${ws 4}";
          "${mod}+5" = "workspace number ${ws 5}";
          "${mod}+6" = "workspace number ${ws 6}";
          "${mod}+7" = "workspace number ${ws 7}";
          "${mod}+8" = "workspace number ${ws 8}";
          "${mod}+9" = "workspace number ${ws 9}";
          "${mod}+0" = "workspace number ${ws 0}";

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
          "${mod}+equal" = "[class=\"chatgpt\"] scratchpad show";
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
              background = "${colorBackgroundBar}";
              statusline = "${colorDominant}";
              separator = "${colorDrab}";
              focusedWorkspace = {
                border = "${colorBackgroundBar}";
                background = "${colorBackgroundBar}";
                text = "${colorProminent}";
              };
              activeWorkspace = {
                border = "${colorBackgroundBar}";
                background = "${colorBackgroundBar}";
                text = "${colorProminent}";
              };
              inactiveWorkspace = {
                border = "${colorBackgroundBar}";
                background = "${colorBackgroundBar}";
                text = "${colorDominant}";
              };
              urgentWorkspace = {
                border = "${colorBackgroundBar}";
                background = "${colorBackgroundBar}";
                text = "${colorAlert}";
              };
              bindingMode = {
                border = "${colorBackgroundBar}";
                background = "${colorProminent}";
                text = "${colorBackgroundBar}";
              };
            };
          }
        ];

        workspaceLayout = "default";
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
          # xprop
          # instance = WM_CLASS[0]
          # class = WM_CLASS[1]
          # title = _NET_WM_NAME, WM_NAME
          # watch xdotool getwindowfocus getwindowgeometry

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

            # ChatGPT
            {
              criteria = { class = "chatgpt"; };
              command = "floating enable";
            }
            {
              criteria = { class = "chatgpt"; };
              command = "move absolute position 565 180";
            }
            {
              criteria = { class = "chatgpt"; };
              command = "resize set 1395 1110";
            }
            {
              criteria = { class = "chatgpt"; };
              command = "move scratchpad";
            }
            {
              criteria = { class = "chatgpt"; };
              command = "fullscreen disable";
            }
            # Spotify (assign does not work)
            {
              criteria = { class = "Spotify"; };
              command = "move workspace ${ws 9}";
            }

            # lyrics
            {
              criteria = { class = "lyrics"; };
              command = "resize set width 441 px";
            }

            # cmus
            {
              criteria = { class = "cmus"; };
              command = "resize set width 812 px";
            }

          ];
        };

        assigns = {
          "${ws 8}" = [
            { class = "^discord$"; }
            { class = "^weechat$"; }
          ];
          "${ws 9}" = [
            { class = "^cmus$"; }
            { class = "^lyrics$"; }
          ];
        };

        startup = [
          { command = "Enpass"; notification = false; }
          # { command = "${pkgs.i3wsr}/bin/i3wsr --config ${i3wsrConfig}"; notification = false; }
          { command = "xrandr --output HDMI-0 --left-of DP-2"; notification = false; }
          { command = "hsetroot --screens 1 -solid \"#555555\""; notification = false; }
          { command = "i3-msg workspace '${ws 1}'"; notification = false; }
          { command = "firefox --kiosk --no-remote -P chatgpt --class chatgpt https://chat.openai.com"; notification = false; }
          { command = "discord"; notification = false; }
          { command = "spotify"; notification = false; }
          { command = "alacritty --class weechat --command weechat"; notification = false; }
          { command = "alacritty --class cmus --command ${startCmus}/bin/startCmus"; notification = false; }
          { command = "alacritty --class lyrics --command sptlrx"; notification = false; }

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
    pkgs.feh
  ];
}
