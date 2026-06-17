{ config, ... }:

{
  users.users.immich.extraGroups = [ "video" "render" ];
  services = {
    redis.servers.immich.logLevel = "warning";
    immich = {
      enable = true;
      host = "127.0.0.1";
      port = 2283;
      redis.enable = true;
      database.createDB = true;
      secretsFile = config.sops.secrets."immich".path;
      accelerationDevices = null; # All
      mediaLocation = "/srv/immich";
    };
  };

  # Immich is really, REALLY pedantic
  systemd.tmpfiles.rules = [
    "d /srv/immich 0700 immich immich -"
    "d /srv/immich/upload 0700 immich immich -"
    "d /srv/immich/profile 0700 immich immich -"
    "d /srv/immich/thumbs 0700 immich immich -"
    "d /srv/immich/library 0700 immich immich -"
    "d /srv/immich/backups 0700 immich immich -"
    "d /srv/immich/encoded-video 0700 immich immich -"

    "f /srv/immich/upload/.immich 0600 immich immich - upload"
    "f /srv/immich/profile/.immich 0600 immich immich - profile"
    "f /srv/immich/thumbs/.immich 0600 immich immich - thumbs"
    "f /srv/immich/library/.immich 0600 immich immich - library"
    "f /srv/immich/backups/.immich 0600 immich immich - backups"
    "f /srv/immich/encoded-video/.immich 0600 immich immich - encoded-video"
  ];

  services.caddy.virtualHosts."photos.heartblin.eu" = {
    useACMEHost = "heartblin.eu";
    extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.immich.port}
    '';
  };
}
