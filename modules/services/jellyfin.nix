{ pkgs, ... }:

{
  services.jellyfin = {
    enable = true;
    user = "jellyfin";
  };

  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  users.users.jellyfin = {
    isSystemUser = true;
    extraGroups = [ "render" "video" "users" ];
  };

  services.caddy.virtualHosts."movies.heartblin.eu" = {
    useACMEHost = "heartblin.eu";
    extraConfig = ''
      reverse_proxy http://localhost:8096
    '';
  };
}
