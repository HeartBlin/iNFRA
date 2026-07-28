{ config, self, ... }:

{
  age.secrets.immich = {
    file = "${self}/secrets/immich/env.age";
    owner = "immich";
    group = "immich";
    mode = "0400";
  };

  users.users.immich.extraGroups = [ "video" "render" ];
  services = {
    redis.servers.immich.logLevel = "warning";
    immich = {
      enable = true;
      host = "127.0.0.1";
      port = 2283;
      redis.enable = true;
      database.createDB = true;
      secretsFile = config.age.secrets.immich.path;
      accelerationDevices = null;
      mediaLocation = "/mnt/storage/immich";
    };
  };

  # Pedantic "dont get ass-bit"
  systemd.tmpfiles.rules = [
    "d /mnt/storage/immich 0700 immich immich -"
    "d /mnt/storage/immich/upload 0700 immich immich -"
    "d /mnt/storage/immich/profile 0700 immich immich -"
    "d /mnt/storage/immich/thumbs 0700 immich immich -"
    "d /mnt/storage/immich/library 0700 immich immich -"
    "d /mnt/storage/immich/backups 0700 immich immich -"
    "d /mnt/storage/immich/encoded-video 0700 immich immich -"

    "f /mnt/storage/immich/upload/.immich 0600 immich immich - upload"
    "f /mnt/storage/immich/profile/.immich 0600 immich immich - profile"
    "f /mnt/storage/immich/thumbs/.immich 0600 immich immich - thumbs"
    "f /mnt/storage/immich/library/.immich 0600 immich immich - library"
    "f /mnt/storage/immich/backups/.immich 0600 immich immich - backups"
    "f /mnt/storage/immich/encoded-video/.immich 0600 immich immich - encoded-video"
  ];
}
