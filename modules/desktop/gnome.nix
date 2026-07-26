{ lib, pkgs, ... }:

let
  # Dconf types
  int32_t = lib.gvariant.mkInt32;
  tuple = lib.gvariant.mkTuple;

  # Vars
  cursor-theme = "Bibata-Modern-Ice";
  cursor-size = int32_t 24;

  # Extensions
  extensions = with pkgs.gnomeExtensions; [
    caffeine
    just-perfection
    vicinae
    blur-my-shell
  ];

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
    ./_ptyxis.nix
    ./_vicinae.nix
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
      gnome-calendar
      gnome-contacts
      gnome-weather
      gnome-maps
      decibels
      gnome-text-editor
    ];

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
    profiles.user.databases = mkDconf {
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

      # Extensions
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = map (ext: ext.extensionUuid) extensions;
      };

      # Just Perfection
      "org/gnome/shell/extensions/just-perfection" = {
        theme = false;
        startup-status = int32_t 0;
        top-panel-position = int32_t 1;
        notification-banner-position = int32_t 4;
        support-notifier-type = int32_t 0;
      };

      # Blur My Shells
      "org/gnome/shell/extensions/blur-my-shell/applications".blur = false;
      "org/gnome/shell/extensions/blur-my-shell/panel".blur = false;
      "org/gnome/shell/extensions/blur-my-shell/overview".style-components = int32_t 2;
    };
  };

  # X11 cursor fix
  hjem.users.primaryUser.files.".icons/${cursor-theme}".source = "${pkgs.bibata-cursors}/share/icons/${cursor-theme}";
}
