{ lib, pkgs, self, ... }:

let
  # Dconf types
  int32_t = lib.gvariant.mkInt32;
  tuple = lib.gvariant.mkTuple;
  string = lib.gvariant.type.string;
  emptyArray = lib.gvariant.mkEmptyArray;

  # Vars
  cursor-theme = "Bibata-Modern-Ice";
  cursor-size = int32_t 24;

  # Extensions
  extensions = with pkgs.gnomeExtensions;
    [
      caffeine
      just-perfection
      vicinae
      blur-my-shell
      no-overview
      bluetooth-battery-meter
    ]
    ++ (with self.packages.${pkgs.stdenv.system}; [
      static-workspace-background
      gradia-capture
    ]);

  # Helpers
  mkDconf = settings: [
    {
      lockAll = true;
      inherit settings;
    }
  ];
in {
  imports = [
    ./_binds.nix
    ./_nautilus.nix
    ./_vicinae.nix
    ./_wallpaper.nix
  ];

  # Get GNOME
  services = {
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };

  environment = {
    # Remove most things tbh
    gnome.excludePackages = with pkgs; [
      gnome-tour
      epiphany
      geary
      yelp
      snapshot
      simple-scan
      totem
      evince
      gnome-contacts
      gnome-maps
      decibels
      gnome-text-editor
      gnome-console
    ];

    sessionVariables.GI_TYPELIB_PATH = [ "${self.packages.${pkgs.stdenv.system}.gnome-rounded-blur}/lib/girepository-1.0" ];

    # Get icons/cursors and extensions
    systemPackages = with pkgs;
      [
        bibata-cursors
        adwaita-icon-theme
      ]
      ++ extensions;
  };

  programs.dconf = {
    enable = true;
    profiles = {
      gdm.databases = mkDconf {
        "org/gnome/desktop/interface" = {
          inherit cursor-theme cursor-size;
        };
      };

      user.databases = mkDconf {
        # Interface
        "org/gnome/desktop/interface" = {
          inherit cursor-theme cursor-size;
          color-scheme = "prefer-dark";
          accent-color = "blue";
          enable-hot-corners = false;
        };

        # Peripherals in general
        "org/gnome/desktop/peripherals/touchpad".natural-scroll = false;
        "org/gnome/desktop/peripherals/mouse".natural-scroll = false;
        "org/gnome/desktop/input-sources".sources = [ (tuple [ "xkb" "ro" ]) ];

        # Things
        "org/gnome/desktop/sound".allow-volume-above-100-percent = true;
        "org/gnome/settings-daemon/plugins/power".power-button-action = "interactive";

        "org/gnome/shell" = {
          # Extensions
          disable-user-extensions = false;
          enabled-extensions = map (ext: ext.extensionUuid) extensions;

          # Nothing in dock
          favorite-apps = emptyArray string;

          # Always show log out
          always-show-log-out = true;
        };

        "org/gnome/mutter".attach-modal-dialogs = false;

        # Just Perfection
        "org/gnome/shell/extensions/just-perfection" = {
          theme = false;
          top-panel-position = int32_t 1;
          notification-banner-position = int32_t 4;
          support-notifier-type = int32_t 0;
        };

        # Blur My Shells
        "org/gnome/shell/extensions/blur-my-shell/applications" = {
          blur = true;
          whitelist = [ "com.mitchellh.ghostty" ];
          sigma = int32_t 30;
          opacity = int32_t 255;
          static-blur = false;
        };

        "org/gnome/shell/extensions/blur-my-shell/panel" = {
          blur = true;
          static-blur = false;
          unblur-in-overview = true;
          sigma = int32_t 0;
        };

        "org/gnome/shell/extensions/blur-my-shell/dash-to-dock".blur = false;
        "org/gnome/shell/extensions/blur-my-shell/overview".style-components = int32_t 2;

        # Bluetooth Battery Meter
        "org/gnome/shell/extensions/Bluetooth-Battery-Meter" = {
          modify-quick-settings = true;
          popup-in-quick-settings = true;
          indicator-type = int32_t 2;
          enable-multi-indicator-mode = true;
          enable-tooltip = false;

          level-indicator-type = int32_t 0;
          level-bar-position = int32_t 1;
          level-indicator-color = int32_t 0;
          circle-widget-color = int32_t 1;

          enable-galaxy-buds-device = true;
        };
      };
    };
  };

  # X11 cursor fix
  hjem.users.primaryUser.files.".icons/${cursor-theme}".source = "${pkgs.bibata-cursors}/share/icons/${cursor-theme}";
}
