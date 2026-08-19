{ inputs, ... }:

{
  services = {
    vaultwarden = {
      enable = true;
      backupDir = "/mnt/storage/backups/vaultwarden";
      config = {
        DOMAIN = "https://vault.${inputs.stigmata.constants.domain}";
        SIGNUPS_ALLOWED = "false";
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = "8222";
        ROCKET_LOG = "critical";
        SHOW_PASSWORD_HINT = "false";
        INVITATIONS_ALLOWED = "false";
      };
    };

    caddy.virtualHosts."vault.${inputs.stigmata.constants.domain}".extraConfig = ''
      ${inputs.stigmata.constants.mTLS}
      reverse_proxy http://127.0.0.1:8222
    '';
  };
}
