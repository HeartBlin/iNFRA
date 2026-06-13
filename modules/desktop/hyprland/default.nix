{ pkgs, ... }:

{
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    dconf.enable = true;
    seahorse.enable = true;
  };

  services.gvfs.enable = true;
  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  environment = {
    pathsToLink = [ "/share/icons" ];
    etc = {
      "xdg/hypr/hyprland.lua".text = builtins.readFile ./hyprland.lua;
      "xdg/hypr/settings.lua".text = builtins.readFile ./settings.lua;
      "xdg/hypr/binds.lua".text = builtins.readFile ./binds.lua;
    };

    systemPackages = with pkgs; [
      libsecret
      nautilus
      file-roller
      hyprshot
      brightnessctl
      glib
      gsettings-desktop-schemas
      networkmanagerapplet
      mako
      libnotify
      blueman
    ];
  };
}
