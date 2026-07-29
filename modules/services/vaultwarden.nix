_:

let
  domain = "heartblin.eu";
in {
  services.vaultwarden = {
    enable = true;
    backupDir = "/mnt/storage/backups/vaultwarden";
    config = {
      DOMAIN = "https://vault.${domain}";
      SIGNUPS_ALLOWED = "false";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = "8222";
      ROCKET_LOG = "critical";
      SHOW_PASSWORD_HINT = "false";
      INVITATIONS_ALLOWED = "false";
    };
  };
}
