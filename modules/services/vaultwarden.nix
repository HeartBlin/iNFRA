{ config, ... }:

{
  services.vaultwarden = {
    enable = true;
    backupDir = "/var/local/vaultwarden/backup";
    config = {
      DOMAIN = "https://vault.heartblind.eu";
      SIGNUPS_ALLOWED = "false";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = "8967";
      ROCKET_LOG = "critical";
      SHOW_PASSWORD_HINT = "false";
      INVITATIONS_ALLOWED = "false";
    };
  };

  services.caddy.virtualHosts."vault.heartblin.eu" = {
    useACMEHost = "heartblin.eu";
    extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.vaultwarden.config.ROCKET_PORT} {
        header_up X-Real-IP {remote_host}
      }
    '';
  };
}
