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
{
  home.file = {
    ".config/i3/config".text = ''
      
      # i3 config file (v4)
      set $mod Mod4
      
      # reload the configuration file
      bindsym $mod+Shift+c reload
      # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
      bindsym $mod+Shift+r restart
      
      # Font for window titles. Will also be used by the bar unless a different font
      # is used in the bar {} block below.
      font pango:CaskaydiaCove Nerd Font Mono 9
      
      # Colors
      # class                 border    backgr    text     indicator child_border
      client.focused          #FFFFFF   #000000   #FFFF00  #FFFFFF   #FFFFFF
      client.focused_inactive #464646   #000000   #FFFF00  #FFFFFF   #464646
      client.unfocused        #464646   #000000   #FFFFFF  #464646   #464646
      client.urgent           #FF0000   #000000   #FFFFFF  #FF0000   #FF0000
      client.placeholder      #464646   #000000   #FFFFFF  #FFFFFF   #FFFF00
      client.background       #000000
      
      # Window decorations
      title_align center
      default_border normal
      hide_edge_borders none
      
      focus_follows_mouse no
      
      # Use Mouse+$mod to drag floating windows to their wanted position
      floating_modifier $mod
      
      # kill focused window
      bindsym $mod+q kill
      
      # start dmenu (a program launcher)
      # sometimes I dont remember exact program name
      bindsym $mod+Shift+d exec rofi -modi drun -show drun -display-drun "" -config /home/primamateria/.config/rofi/config.rasi
      # https://github.com/PrimaMateria/dmenu.git
      # bindsym $mod+d exec --no-startup-id /run/current-system/sw/bin/dmenu_run -nb black -nf white -sb yellow -sf black -l 20 -c
      bindsym $mod+d exec --no-startup-id dmenu_run -nb black -nf white -sb yellow -sf black -l 20
      
      # change focus
      bindsym $mod+h focus left
      bindsym $mod+j focus down
      bindsym $mod+k focus up
      bindsym $mod+l focus right
      bindsym $mod+Tab focus next
      bindsym $mod+Shift+Tab focus next sibling
      bindsym $mod+space focus mode_toggle
      bindsym $mod+a focus parent
      bindsym $mod+z focus child
      
      # move focused window
      bindsym $mod+Shift+h move left
      bindsym $mod+Shift+j move down
      bindsym $mod+Shift+k move up
      bindsym $mod+Shift+l move right
      
      # enter fullscreen mode for the focused container
      bindsym $mod+f fullscreen toggle
      
      # change container layout (stacked, tabbed, toggle split)
      bindsym $mod+F2 layout tabbed
      bindsym $mod+F3 layout splith
      bindsym $mod+F4 layout splitv
      bindsym $mod+F5 layout stacked
      # magic command. It turns window to a container with stacking layout containing
      # only that window. But the next window opened will belong to this new
      # sub-container.
      bindsym $mod+F6 split horizontal, layout stacking
      workspace_layout tabbed
      
      # toggle tiling / floating
      bindsym $mod+Shift+space floating toggle
      
      # Define names for default workspaces for which we configure key bindings later on.
      # We use variables to avoid repeating the names in multiple places.
      set $ws1 "1:"
      set $ws2 "2:"
      set $ws3 "3:"
      set $ws4 "4:"
      set $ws5 "5:"
      set $ws6 "6:"
      set $ws7 "7:"
      set $ws8 "8:"
      set $ws9 "9:"
      set $ws10 "0:"
      
      # switch to workspace
      bindsym $mod+1 workspace number $ws1
      bindsym $mod+2 workspace number $ws2
      bindsym $mod+3 workspace number $ws3
      bindsym $mod+4 workspace number $ws4
      bindsym $mod+5 workspace number $ws5
      bindsym $mod+6 workspace number $ws6
      bindsym $mod+7 workspace number $ws7
      bindsym $mod+8 workspace number $ws8
      bindsym $mod+9 workspace number $ws9
      bindsym $mod+0 workspace number $ws10
      
      # workspace quick navigation
      bindsym $mod+grave exec workspace back_and_forth
      
      # move focused container to workspace
      bindsym $mod+Shift+1 move container to workspace number $ws1
      bindsym $mod+Shift+2 move container to workspace number $ws2
      bindsym $mod+Shift+3 move container to workspace number $ws3
      bindsym $mod+Shift+4 move container to workspace number $ws4
      bindsym $mod+Shift+5 move container to workspace number $ws5
      bindsym $mod+Shift+6 move container to workspace number $ws6
      bindsym $mod+Shift+7 move container to workspace number $ws7
      bindsym $mod+Shift+8 move container to workspace number $ws8
      bindsym $mod+Shift+9 move container to workspace number $ws9
      bindsym $mod+Shift+0 move container to workspace number $ws10
      
      # resize window (you can also use the mouse for that)
      mode "resize" {
              # These bindings trigger as soon as you enter the resize mode
      
              # Pressing left will shrink the window’s width.
              # Pressing right will grow the window’s width.
              # Pressing up will shrink the window’s height.
              # Pressing down will grow the window’s height.
              bindsym h resize shrink width 10 px or 10 ppt
              bindsym j resize grow height 10 px or 10 ppt
              bindsym k resize shrink height 10 px or 10 ppt
              bindsym l resize grow width 10 px or 10 ppt
      
              # same bindings, but for the arrow keys
              bindsym Left resize shrink width 10 px or 10 ppt
              bindsym Down resize grow height 10 px or 10 ppt
              bindsym Up resize shrink height 10 px or 10 ppt
              bindsym Right resize grow width 10 px or 10 ppt
      
              # back to normal: Enter or Escape or $mod+r
              bindsym Return mode "default"
              bindsym Escape mode "default"
              bindsym $mod+r mode "default"
      }
      
      bindsym $mod+r mode "resize"
      
      # Move current window to and from scratchpad
      bindsym $mod+x move scratchpad
      bindsym $mod+shift+x exec /home/primamateria/Applications/i3-scratchpad-dmenu/i3-scratchpad-dmenu.py
      
      # Start i3bar to display a workspace bar (plus the system information i3status
      # finds out, if available)
      bar {
      	position top
        status_command i3blocks
      	strip_workspace_numbers no
      	colors {
      		background #000000
      		statusline #FFFFFF
      		separator  #464646
      		#class             border  bg      text	
      		focused_workspace  #000000 #000000 #FFFF00
      		active_workspace   #000000 #000000 #FFFF00
      		inactive_workspace #000000 #000000 #FFFFFF
      		urgent_workspace   #000000 #000000 #FF0000
      		binding_mode       #000000 #FFFF00 #000000
        }
      }
      
      # Background
      exec --no-startup-id hsetroot -solid "#111111"
      
      # Power management
      set $Locker i3lock && sleep 1
      
      set $mode_system System (e) logout, (s) suspend, (r) reboot, (Shift+s) shutdown
      mode "$mode_system" {
          bindsym e exec --no-startup-id i3-msg exit, mode "default"
          bindsym s exec --no-startup-id systemctl suspend, mode "default"
          bindsym r exec --no-startup-id systemctl reboot, mode "default"
          bindsym Shift+s exec --no-startup-id systemctl poweroff -i, mode "default"  
      
          # back to normal: Enter or Escape
          bindsym Return mode "default"
          bindsym Escape mode "default"
      }
      
      bindsym $mod+shift+e mode "$mode_system
      
      # Keyboard layouts
      #exec --no-startup-id "setxkbmap -layout us,de,sk -variant ,qwerty,qwerty -option \"grp:alt_caps_toggle\""
      
      # i3blocks keyindeicator
      bindsym --release Caps_Lock exec pkill -SIGRTMIN+11 i3blocks
      bindsym --release Num_Lock  exec pkill -SIGRTMIN+11 i3blocks
      
      # Renaming workspaces
      #bindsym $mod+comma exec i3-input -F 'rename workspace to "%s"' -P 'New name: '
      exec --no-startup-id /usr/bin/i3wsr --config /home/primamateria/.config/i3wsr/config.toml
      
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
      
      # Enpass
      bindsym $mod+minus [class="Enpass" title="^Enpass$"] scratchpad show
      for_window [class="Enpass" title="^Enpass$"] floating enable
      for_window [class="Enpass" title="^Enpass$"] resize set 800 520
      for_window [class="Enpass" title="^Enpass$"] move absolute position 1678 918
      for_window [class="Enpass" title="^Enpass$"] move scratchpad
      exec --no-startup-id Enpass
      
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
      #bindsym $mod+F1 exec "i3 $(cat ~/.config/i3/config | grep 'bindsym' | grep -v '^\s*#' | sed 's/bindsym / /' | dmenu -i -nb black -nf white -sb yellow -sf black -l 50 -c | sed 's/^\s*//' | cut -d' ' -f 2- | sed 's/;/ \&\& i3/g' )"
      
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
}
