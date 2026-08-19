{ config, inputs, pkgs, ... }:

{
  age.secrets.restic-env = {
    file = "${inputs.stigmata}/secrets/restic/env.age";
    owner = "root";
    mode = "0400";
  };

  services.restic.backups.ovh = {
    initialize = true;

    repository = inputs.stigmata.constants.s3;
    environmentFile = config.age.secrets.restic-env.path;

    paths = [
      "/mnt/storage/backups/vaultwarden"
      "/mnt/storage/immich/library"
      "/mnt/storage/media"
      "/mnt/storage/minecraft/world"
    ];

    exclude = [
      "/mnt/storage/media/Anime"
      "/mnt/storage/media/Music"
    ];

    timerConfig = {
      OnCalendar = "03:00 UTC";
      RandomizedDelaySec = "15m";
      Persistent = true;
    };

    backupPrepareCommand = ''
      systemctl stop fabric-server.service sftpgo.service jellyfin.service immich-server.service immich-machine-learning.service
    '';

    backupCleanupCommand = let
      uptime = "http://localhost:3001/api/push/Xw8qxlcH1cE4jymwm3lMhs6xvdpMVtoo";
    in ''
      BACKUP_STATUS=$?

      systemctl start fabric-server.service sftpgo.service jellyfin.service immich-server.service immich-machine-learning.service

      if [ $BACKUP_STATUS -eq 0 ]; then
        ${pkgs.curl}/bin/curl -fsS --retry 3 "${uptime}?status=up&msg=Backup+Successful" > /dev/null
      else
        ${pkgs.curl}/bin/curl -fsS --retry 3 "${uptime}?status=down&msg=Backup+Failed+with+code+$BACKUP_STATUS" > /dev/null
      fi
    '';

    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];

    checkOpts = [ "--with-cache" ];
  };
}
