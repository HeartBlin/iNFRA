{ inputs, pkgs, ... }:

{
  imports = [ inputs.hyprland.nixosModules.default ./_supporting.nix ];
  config = {
    programs = {
      hyprland = {
        enable = true;
        withUWSM = false;
        package = inputs.hyprland.packages.${pkgs.stdenv.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.system}.xdg-desktop-portal-hyprland;
        settings = {
          monitor = [
            "eDP1, 1920x1080@144, 0x0, 1"
            ", highres, auto, 1"
          ];

          env = [
            "XCURSOR_SIZE, 24"
            "SSH_AUTH_SOCK, /run/user/1000/gcr/ssh"
          ];

          exec-once = [
            "systemctl --user start polkit-gnome-authentication-agent-1"
            "hyprctl setcursor Bibata-Modern-Ice 24"
            "foot --server"
            "qs"
            "mako --default-timeout 2000 --ignore-timeout 1"
            "wayscriber --daemon"
            "sleep 2 && nm-applet"
            "sleep 1.5 && blueman-applet"
            "sleep 1 && rog-control-center"
          ];

          general = {
            allow_tearing = true;
            border_size = 2;
            "col.active_border" = "0xffef7e7e 0xffe57474 0xfff4d67a 0xffe5c76b 0xff96d988 0xff8ccf7e 0xff67cbe7 0xff6cbfbf 0xff71baf2 0xffc47fd5 45deg";
            "col.inactive_border" = "0xff444444";
            gaps_in = 5;
            gaps_out = 10;
            resize_on_border = true;
          };

          animations.enabled = false;
          decoration = {
            rounding = 0;
            blur.enabled = false;
            shadow.enabled = true;
          };

          input = {
            follow_mouse = true;
            kb_layout = "ro";
            sensitivity = 0;
            touchpad = {
              clickfinger_behavior = true;
              disable_while_typing = true;
              natural_scroll = false;
              tap-to-click = true;
            };
          };

          render.direct_scanout = true;
          xwayland.force_zero_scaling = true;
          cursor.no_hardware_cursors = true;
          ecosystem = {
            no_donation_nag = true;
            no_update_news = true;
          };

          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            middle_click_paste = false;
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = true;
          };

          windowrule = [ "match:class ^(Waydroid)$, fullscreen on" ];
          bind = [
            "Super Shift, Q, exit"
            "Super, Q, killactive"
            "Super, F, fullscreen"
            "Super, T, togglefloating"

            "Super, Return, exec, footclient"
            "Super, Space, exec, rofi -show drun"
            "Super, E, exec, nautilus"
            "Super, W, exec, chromium"
            "Super, Print, exec, hyprshot -o ~/Pictures/Screenshots -m region"
            ", Print, exec, wayscriber --daemon-toggle --freeze"

            "LAlt, E, exec, qs ipc call wp walk 1"
            "LAlt, Q, exec, qs ipc call wp walk -1"

            "Super, 1, workspace, 1"
            "Super, 2, workspace, 2"
            "Super, 3, workspace, 3"
            "Super, 4, workspace, 4"
            "Super, 5, workspace, 5"
            "Super, 6, workspace, 6"
            "Super, 7, workspace, 7"
            "Super, 8, workspace, 8"
            "Super, 9, workspace, 9"
            "Super, 0, workspace, 10"

            "Super Shift, 1, movetoworkspace, 1"
            "Super Shift, 2, movetoworkspace, 2"
            "Super Shift, 3, movetoworkspace, 3"
            "Super Shift, 4, movetoworkspace, 4"
            "Super Shift, 5, movetoworkspace, 5"
            "Super Shift, 6, movetoworkspace, 6"
            "Super Shift, 7, movetoworkspace, 7"
            "Super Shift, 8, movetoworkspace, 8"
            "Super Shift, 9, movetoworkspace, 9"
            "Super Shift, 0, movetoworkspace, 10"
          ];

          bindm = [
            "Super, mouse:272, movewindow"
            "Super, mouse:273, resizewindow"
          ];

          bindel = [
            ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
            ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-"
            ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
            ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
          ];

          bindl = [ ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" ];
        };
      };
    };
  };
}
