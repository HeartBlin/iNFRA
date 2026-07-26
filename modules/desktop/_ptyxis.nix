{ lib, pkgs, ... }:

let
  mkDconf = settings: [ { inherit settings; } ];

  # Ptyxis code doesn't check if it's an actual UUID.
  # Literal char* btw.
  # I keep it UUID shape if they suddenly decide validating it is a good idea
  distinctlyNotAnUUID = "1234567890abcdef1234567890abcdef";
  settings = {
    restore-session = false;
    interface-style = "dark";
    profile-uuids = [ distinctlyNotAnUUID ];
    default-profile-uuid = distinctlyNotAnUUID;
    use-system-font = false;
    font-name = "CaskaydiaCove Nerd Font Italic 12";
    cursor-blink-mode = "off";
    label = "Kantai";
    palette = "kantai";
  };

  # "It's a surprise tool that will help us later"
  settingsHash = builtins.hashString "sha256" (builtins.toJSON settings);
in {
  environment = {
    systemPackages = [ pkgs.ptyxis ];
    gnome.excludePackages = [ pkgs.gnome-console ];
  };

  programs.dconf.profiles.user.databases = mkDconf {
    "org/gnome/desktop/default-applications/terminal".exec = "ptyxis";

    "org/gnome/Ptyxis" = {
      inherit
        (settings)
        restore-session
        interface-style
        profile-uuids
        default-profile-uuid
        use-system-font
        font-name
        cursor-blink-mode
        ;
    };

    "org/gnome/Ptyxis/Profiles/${distinctlyNotAnUUID}" = {
      inherit (settings) label palette;
    };
  };

  hjem.users.primaryUser.files.".local/share/org.gnome.Ptyxis/palettes/kantai.palette".text = lib.generators.toINI { } rec {
    Palette.Name = "Kantai";
    Light = Dark;
    Dark = rec {
      Foreground = "#dadada";
      Background = "#141b1e";
      TitlebarForeground = "#ffffff";
      TitlebarBackground = "#2e2e32";
      Cursor = Foreground;

      Color0 = "#232a2d";
      Color1 = "#e57474";
      Color2 = "#8ccf7e";
      Color3 = "#e5c76b";
      Color4 = "#67b0e8";
      Color5 = "#c47fd5";
      Color6 = "#6cbfbf";
      Color7 = "#b3b9b8";

      Color8 = "#2d3437";
      Color9 = "#ef7e7e";
      Color10 = "#96d988";
      Color11 = "#f4d67a";
      Color12 = "#71baf2";
      Color13 = "#ce89df";
      Color14 = "#67cbe7";
      Color15 = "#bdc3c2";
    };
  };

  fonts = {
    packages = [ pkgs.nerd-fonts.caskaydia-cove ];
    # Trick ptyxis into having italics
    fontconfig.localConf = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
        <match target="pattern">
          <test name="prgname" compare="eq"><string>ptyxis</string></test>
          <test name="family" compare="eq"><string>CaskaydiaCove Nerd Font</string></test>
          <test name="slant" compare="eq"><int>0</int></test>
          <edit name="slant" mode="assign"><int>100</int></edit>
        </match>
      </fontconfig>
    '';
  };

  # Reset when anything changes in case it wrote to dconf itself
  # It does write into .config
  # I spent 1h on why my UUID trick didnt work
  # dconf reset -f /org/gnome/Ptyxis/ everytime things change
  # Fuck it
  systemd.user.services.reset-ptyxis-dconf = {
    description = "Purge mutable Ptyxis state [${settingsHash}]";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.dconf}/bin/dconf reset -f /org/gnome/Ptyxis/";
    };
  };
}
