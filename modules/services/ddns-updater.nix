{ config, lib, self, ... }:

{
  age.secrets.ddns-updater = {
    file = "${self}/secrets/ovh/ddns-updater.json.age";
    owner = "ddns-updater";
    group = "ddns-updater";
    mode = "0400";
  };

  services.ddns-updater = {
    enable = true;
    environment = {
      SERVER_ENABLE = "no";
      CONFIG_FILEPATH = config.age.secrets.ddns-updater.path;
      PERIOD = "5m";
    };
  };

  # Don't compromise on 0400
  users.groups.ddns-updater = { };
  users.users.ddns-updater = {
    isSystemUser = true;
    group = "ddns-updater";
  };

  systemd.services.ddns-updater.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "ddns-updater";
    Group = "ddns-updater";
  };
}
