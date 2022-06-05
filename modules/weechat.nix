{ pkgs, ... }:
let 
  theme_nioh2 = ''
    /set aspell.color.misspelled "lightred"
    /set aspell.color.suggestions "default"
    /set irc.color.input_nick "lightcyan"
    /set irc.color.item_away "red"
    /set irc.color.item_channel_modes "yellow"
    /set irc.color.item_lag_counting "default"
    /set irc.color.item_lag_finished "yellow"
    /set irc.color.message_join "green"
    /set irc.color.message_quit "red"
    /set irc.color.mirc_remap "1,-1:darkgray"
    /set irc.color.nick_prefixes "q:lightred;a:lightcyan;o:lightgreen;h:lightmagenta;v:yellow;*:lightblue"
    /set irc.color.notice "green"
    /set irc.color.reason_quit "default"
    /set irc.color.topic_new "white"
    /set irc.color.topic_old "darkgray"
    /set logger.color.backlog_end "darkgray"
    /set logger.color.backlog_line "darkgray"
    /set relay.color.client "cyan"
    /set relay.color.status_active "lightblue"
    /set relay.color.status_auth_failed "lightred"
    /set relay.color.status_connecting "yellow"
    /set relay.color.status_disconnected "lightred"
    /set relay.color.status_waiting_auth "brown"
    /set relay.color.text "default"
    /set relay.color.text_bg "default"
    /set relay.color.text_selected "white"
    /set weechat.bar.input.color_bg "default"
    /set weechat.bar.input.color_delim "cyan"
    /set weechat.bar.input.color_fg "default"
    /set weechat.bar.nicklist.color_bg "default"
    /set weechat.bar.nicklist.color_delim "cyan"
    /set weechat.bar.nicklist.color_fg "default"
    /set weechat.bar.status.color_bg "237"
    /set weechat.bar.status.color_delim "cyan"
    /set weechat.bar.status.color_fg "default"
    /set weechat.bar.title.color_bg "237"
    /set weechat.bar.title.color_delim "cyan"
    /set weechat.bar.title.color_fg "default"
    /set weechat.color.bar_more "lightmagenta"
    /set weechat.color.chat "default"
    /set weechat.color.chat_bg "default"
    /set weechat.color.chat_buffer "white"
    /set weechat.color.chat_channel "white"
    /set weechat.color.chat_day_change "cyan"
    /set weechat.color.chat_delimiters "green"
    /set weechat.color.chat_highlight "yellow"
    /set weechat.color.chat_highlight_bg "red"
    /set weechat.color.chat_host "cyan"
    /set weechat.color.chat_inactive_buffer "245"
    /set weechat.color.chat_inactive_window "245"
    /set weechat.color.chat_nick "lightcyan"
    /set weechat.color.chat_nick_colors "214,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,cyan,magenta,green,brown,lightblue,default,lightcyan,lightmagenta,lightgreen,yellow"
    /set weechat.color.chat_nick_offline "darkgray"
    /set weechat.color.chat_nick_offline_highlight "default"
    /set weechat.color.chat_nick_offline_highlight_bg "darkgray"
    /set weechat.color.chat_nick_other "cyan"
    /set weechat.color.chat_nick_prefix "green"
    /set weechat.color.chat_nick_self "white"
    /set weechat.color.chat_nick_suffix "green"
    /set weechat.color.chat_prefix_action "white"
    /set weechat.color.chat_prefix_buffer "brown"
    /set weechat.color.chat_prefix_buffer_inactive_buffer "245"
    /set weechat.color.chat_prefix_error "yellow"
    /set weechat.color.chat_prefix_join "lightgreen"
    /set weechat.color.chat_prefix_more "lightmagenta"
    /set weechat.color.chat_prefix_network "magenta"
    /set weechat.color.chat_prefix_quit "lightred"
    /set weechat.color.chat_prefix_suffix "green"
    /set weechat.color.chat_read_marker "green"
    /set weechat.color.chat_read_marker_bg "default"
    /set weechat.color.chat_server "brown"
    /set weechat.color.chat_tags "red"
    /set weechat.color.chat_text_found "yellow"
    /set weechat.color.chat_text_found_bg "lightmagenta"
    /set weechat.color.chat_time "default"
    /set weechat.color.chat_time_delimiters "default"
    /set weechat.color.chat_value "cyan"
    /set weechat.color.emphasized "yellow"
    /set weechat.color.emphasized_bg "magenta"
    /set weechat.color.input_actions "lightgreen"
    /set weechat.color.input_text_not_found "red"
    /set weechat.color.nicklist_away "cyan"
    /set weechat.color.nicklist_group "green"
    /set weechat.color.nicklist_offline "blue"
    /set weechat.color.separator "237"
    /set weechat.color.status_count_highlight "magenta"
    /set weechat.color.status_count_msg "brown"
    /set weechat.color.status_count_other "default"
    /set weechat.color.status_count_private "green"
    /set weechat.color.status_data_highlight "lightmagenta"
    /set weechat.color.status_data_msg "yellow"
    /set weechat.color.status_data_other "default"
    /set weechat.color.status_data_private "lightgreen"
    /set weechat.color.status_filter "yellow"
    /set weechat.color.status_more "yellow"
    /set weechat.color.status_name "white"
    /set weechat.color.status_name_ssl "lightgreen"
    /set weechat.color.status_number "yellow"
    /set weechat.color.status_time "default"
    /set weechat.look.buffer_time_format "%H:%M"
    /set weechat.look.color_inactive_buffer "off"
    /set weechat.look.color_inactive_message "on"
    /set weechat.look.color_inactive_prefix "on"
    /set weechat.look.color_inactive_prefix_buffer "on"
    /set weechat.look.color_inactive_time "off"
    /set weechat.look.color_inactive_window "on"
    /set weechat.look.color_nick_offline "off"
    /set xfer.color.status_aborted "lightred"
    /set xfer.color.status_active "lightblue"
    /set xfer.color.status_connecting "yellow"
    /set xfer.color.status_done "lightgreen"
    /set xfer.color.status_failed "lightred"
    /set xfer.color.status_waiting "lightcyan"
    /set xfer.color.text "default"
    /set xfer.color.text_bg "default"
    /set xfer.color.text_selected "white"
    '';
in
{
  home.packages = [
    (pkgs.weechat.override {
      configure = { ... }: {
        init =
          theme_nioh2 + 
          import ../.secrets/weechat.nix +
          ''
            /set irc.look.smart_filter on
            /filter add irc_smart * irc_smart_filter *
            /set irc.look.server_buffer independent
            /mouse enable

            /server add libera irc.libera.chat
            /set irc.server.libera.addresses "irc.libera.chat/6697"
            /set irc.server.libera.ssl on
            /set irc.server.libera.autoconnect on
            /set irc.server.libera.autojoin "#java,#javascript,#linux,#archlinux,#archlinux-newbie,#gaminigonlinux,#react,#i3,##programming,##electronics,#neovim,#nixos,#xeserv"

            /set script.scripts.download_enabled on
            /script install autosort.py
            /script install emoji.lua
            /script install go.py
            /key bind meta-j /go
          '';
      };
    })
  ];
}
