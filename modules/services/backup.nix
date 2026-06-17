{ config, ... }:

{
  services.restic.backups = {
    vaultwarden = {
      repository = "s3:https://s3.eu-central-lz-buh-a.cloud.ovh.net/heartblin/vaultwarden";
      paths = [ "/var/local/vaultwarden/backup" ];
      initialize = true;

      passwordFile = config.sops.secrets."restic_pass".path;
      environmentFile = config.sops.secrets."ovh_env".path;

      progressFps = 0.1;
      timerConfig = {
        OnCalendar = "*-*-* 01:00:00";
        Persistent = true;
        RandomizedDelaySec = "30m";
      };

      extraBackupArgs = [ "--compression max" ];

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 3"
        "--keep-monthly 3"
      ];
    };

    immich = {
      repository = "s3:https://s3.eu-central-lz-buh-a.cloud.ovh.net/heartblin/immich";
      paths = [ "/srv/immich/upload" "/srv/immich/library" ];
      initialize = true;

      passwordFile = config.sops.secrets."restic_pass".path;
      environmentFile = config.sops.secrets."ovh_env".path;

      progressFps = 0.1;
      timerConfig = {
        OnCalendar = "*-*-* 04:00:00";
        Persistent = true;
        RandomizedDelaySec = "30m";
      };

      extraBackupArgs = [ "--compression max" ];
      pruneOpts = [
        "--keep-last 2"
        "--keep-monthly 1"
      ];

      backupPrepareCommand = ''
        systemctl stop immich-server.service immich-machine-learning.service
      '';

      backupCleanupCommand = ''
        systemctl start immich-server.service immich-machine-learning.service
      '';
    };
  };
}
