{ lib, ... }:

let
  # Types
  int32_t = lib.gvariant.mkInt32;
  string = lib.gvariant.type.string;
  emptyArray = lib.gvariant.mkEmptyArray;

  # To make the settings part not ugly as sin
  mkDconf = settings: [ { inherit settings; } ];

  workspace-num = 5;

  # To not type the same thing 7 billion times
  workspaceBinds = prefix: val:
    builtins.listToAttrs (map
      (i: let w = builtins.toString i; in lib.nameValuePair "${prefix}-${w}" (val w))
      (lib.range 1 workspace-num));

  # Binds for apps (its actually for any command shh)
  binds = [
    {
      name = "Chromium";
      command = "chromium";
      binding = "<Super>W";
    }
    {
      name = "VSCodium";
      command = "codium";
      binding = "<Super>C";
    }
    {
      name = "Terminal";
      command = "ghostty +new-window";
      binding = "<Super>Return";
    }
    {
      name = "Vicinae";
      command = "vicinae toggle";
      binding = "<Super>Space";
    }
    {
      name = "Switch Wallpaper";
      command = "switch-wallpaper";
      binding = "<Super>R";
    }
    {
      name = "Nautilus";
      command = "nautilus -w";
      binding = "<Super>E";
    }
  ];

  # Hell mode (generate binds)
  base = "org/gnome/settings-daemon/plugins/media-keys";
  customBinds =
    {
      "${base}".custom-keybindings =
        lib.imap0 (i: _: "/${base}/custom-keybindings/custom${toString i}/") binds;
    }
    // lib.listToAttrs (
      lib.imap0 (i: bind: lib.nameValuePair "${base}/custom-keybindings/custom${toString i}" bind) binds
    );
in {
  programs.dconf.profiles.user.databases = mkDconf (customBinds
    // {
      # Window Management
      "org/gnome/mutter".dynamic-workspaces = false;
      "org/gnome/desktop/wm/preferences".num-workspaces = int32_t workspace-num;

      "org/gnome/desktop/wm/keybindings" =
        {
          close = [ "<Super>q" ];
          switch-input-source = emptyArray string;
          switch-input-source-backward = emptyArray string;
        }
        # Workspaces
        // workspaceBinds "switch-to-workspace" (ws: [ "<Super>${ws}" ])
        // workspaceBinds "move-to-workspace" (ws: [ "<Shift><Super>${ws}" ]);

      # Unbind those shits
      "org/gnome/shell/keybindings" = workspaceBinds "switch-to-application" (_: emptyArray string);
    });
}
