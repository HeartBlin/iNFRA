{ pkgs, ... }:

{
  programs = {
    dconf.enable = true;
    seahorse.enable = true;
  };

  services = {
    gvfs.enable = true;
    gnome = {
      gcr-ssh-agent.enable = true;
      gnome-keyring.enable = true;
    };
  };

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
