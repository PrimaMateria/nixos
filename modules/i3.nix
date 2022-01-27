# __/\\\\\\\\\\\_____/\\\\\\\\\\__        
#  _\/////\\\///____/\\\///////\\\_       
#   _____\/\\\______\///______/\\\__      
#    _____\/\\\_____________/\\\//___     
#     _____\/\\\____________\////\\\__    
#      _____\/\\\_______________\//\\\_   
#       _____\/\\\______/\\\______/\\\__  
#        __/\\\\\\\\\\\_\///\\\\\\\\\/___ 
#         _\///////////____\/////////_____

{pkgs, config, lib, ...}:
let
  i3blocksConfig = pkgs.copyPathToStore ../configs/i3blocks.conf;
  i3wsrConfig = pkgs.copyPathToStore ../configs/i3wsr.toml;
in
{
  services.picom.enable = true;
  services.blueman-applet.enable = true;

  xsession.windowManager.i3 = {
    enable = true;
    config = let
      mod = "Mod4";

      colorDominant = "#FFFFFF";
      colorProminent = "#FFFF00";
      colorDrab = "#464646";
      colorBackground = "#000000";
      colorAlert = "#FF0000";

      workspaces = ["0:" "1:" "2:" "3:" "4:" "5:" "6:" "7:" "8:" "9:"];
      ws = n: builtins.elemAt workspaces n;

      cmdMenu = "dmenu_run -nb black -nf white -sb yellow -sf black -l 20";
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
        "${mod}+Shift+Tab" = "focus next sibling";
        "${mod}+Space" = "focus mode_toggle";

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
      defaultWorkspace = "${ws 1}";

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
          {
            criteria = { class = "Enpass"; title = "^Enpass$"; };
            command = "floating enable; resize set 800 520; move absolute position 1678 918; move scratchpad";
          }
        ];
      };

      startup = [
        { command = "Enpass"; notification = false; }
        { command = "${pkgs.i3wsr}/bin/i3wsr --config ${i3wsrConfig}"; notification = false; }
        { command = "hsetroot -solid \"#111111\""; notification = false; }
      ];
    };
    extraConfig = ''
      title_align center
      default_border normal
    '';
  };

  /*
  home.file = {
    ".config/i3/config".text = ''
      # Move current window to and from scratchpad
      bindsym $mod+shift+x exec /home/primamateria/Applications/i3-scratchpad-dmenu/i3-scratchpad-dmenu.py
      
      # Keyboard layouts
      #exec --no-startup-id "setxkbmap -layout us,de,sk -variant ,qwerty,qwerty -option \"grp:alt_caps_toggle\""
      
      # i3blocks keyindeicator
      bindsym --release Caps_Lock exec pkill -SIGRTMIN+11 i3blocks
      bindsym --release Num_Lock  exec pkill -SIGRTMIN+11 i3blocks
      
      ####################################################################################################
      # Applications
      ####################################################################################################
      # xprop
      # instance = WM_CLASS[0]
      # class = WM_CLASS[1]
      # title = _NET_WM_NAME, WM_NAME
      # watch xdotool getwindowfocus getwindowgeometry
      
      # Nvidia settings
      #bindsym $mod+ctrl+n [class="Nvidia-settings"] scratchpad show
      #for_window [class="Nvidia-settings"] move scratchpad
      #exec --no-startup-id nvidia-settings
      
      # Crow Translate
      #bindsym $mod+plus  [class="Crow Translate" title="Crow Translate"] scratchpad show
      #for_window [class="Crow Translate" title="Crow Translate"] floating enable
      #for_window [class="Crow Translate" title="Crow Translate"] resize set 930 300
      #for_window [class="Crow Translate" title="Crow Translate"] move absolute position 1628 1139
      #for_window [class="Crow Translate" title="Crow Translate"] move scratchpad
      #exec --no-startup-id /usr/bin/crow
      
      # Alacritty
      bindsym ctrl+grave [class="Alacritty" title="alphaTerminal"] scratchpad show
      for_window [class="Alacritty" title="alphaTerminal"] floating enable
      for_window [class="Alacritty" title="alphaTerminal"] move absolute position 750 290
      #size is set in the alacrity config file
      #for_window [class="Alacritty" title="alphaTerminal"] resize set 1530 300
      for_window [class="Alacritty" title="alphaTerminal"] move scratchpad
      exec --no-startup-id "FLOATER=1 alacritty -t alphaTerminal"
      bindsym $mod+Return exec alacritty
      
      # Calculator
      #bindsym XF86Calculator [class="Qalculate-gtk"] scratchpad show
      #for_window [class="Qalculate-gtk"] floating enable
      #for_window [class="Qalculate-gtk"] resize set 800 540
      #for_window [class="Qalculate-gtk"] move absolute position 1753 895
      #for_window [class="Qalculate-gtk"] move scratchpad
      #exec --no-startup-id /usr/bin/qalculate-gtk 
      
      # Goldendict
      #bindsym $mod+g [class="GoldenDict" title="^.*GoldenDict$"] scratchpad show
      #for_window [class="GoldenDict" title="^.*GoldenDict$"] floating enable
      #for_window [class="GoldenDict" title="^.*GoldenDict$"] resize set 1210 910
      #for_window [class="GoldenDict" title="^.*GoldenDict$"] move absolute position 750 290
      #for_window [class="GoldenDict" title="^.*GoldenDict$"] move scratchpad
      #exec --no-startup-id /usr/bin/goldendict
      
      # ScreenSync (LED Colors sync with display)
      #for_window [class="Screensync v0.1"] move scratchpad
      #exec --no-startup-id /usr/bin/python /home/primamateria/development/projects/ScreenSync/screensync.py
      
      # Browser
      set $browser firefox
      bindsym $mod+shift+Return exec $browser
      
      # Steam
      #exec --no-startup-id "/usr/bin/steam -silent %U"
      
      # Skype
      # exec --no-startup-id "/usr/bin/skypeforlinux %U"
      
      # Google Drive sync
      #exec --no-startup-id "rclone --vfs-cache-mode writes mount \"gdrive\": ~/gdrive"
      
      # Bluetooth
      #exec --no-startup-id "/usr/bin/blueman-applet"
      
      # Programming playlist
      #bindsym ctrl+shift+9 exec mpv --no-resume-playback --no-video 'https://www.youtube.com/playlist?list=PLjDqZb1FVlst1XPXongf5UD02yU9Md-ot' --input-ipc-server=/tmp/programmingPlaylist
      #bindsym ctrl+shift+0 exec "echo 'cycle pause' | socat - /tmp/programmingPlaylist"
      #bindsym ctrl+shift+minus exec "echo 'playlist-next' | socat - /tmp/programmingPlaylist"
      
      # i3 bindsyms in dmenu
      #bindsym $mod+F1 exec "i3 $(cat ~/.config/i3/config | grep 'bindsym' | grep -v '^\s*#' | sed 's/bindsym / /' | dmenu -i -nb black -nf white -sb yellow -sf black -l 50 -c | sed 's/^\s//' | cut -d' ' -f 2- | sed 's/;/ \&\& i3/g' )"
      
      # java sdkman
      #exec --no-startup-id "source ~/.sdkman/bin/sdkman-init.sh"
      
      # i3blocks-gcalcli
      #for_window [class="XTerm" title="i3blocks-gcalcli"] floating enable
      #for_window [class="XTerm" title="i3blocks-gcalcli"] move absolute position 1665 25
      #for_window [class="XTerm" title="i3blocks-gcalcli"] border none
      
      # dunst for notify-send
      #exec --no-startup-id "/usr/bin/dunst"
      
      # Suckman
      #bindsym ctrl+shift+d exec --no-startup-id "/home/primamateria/development/projects/suckman/target/release/suckman menu"
      #for_window [instance="Suckman" title="status"] floating enable
      
      # Spotify
      #for_window [class="Spotify" title="Spotify"] move scratchpad
      #exec --no-startup-id "/usr/bin/spotify"
    '';
    };
  */

  home.packages = with pkgs; [
    dmenu
    i3blocks
    hsetroot
    i3block-datetime
    i3wsr
  ];
}
