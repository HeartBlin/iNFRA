let
  keys = import ./secrets/keys.nix;
  inherit (keys) Void Reason Finality;
  allWithBackup = [ Void Reason Finality ];
in {
  "secrets/ovh/dns.age".publicKeys = allWithBackup;
  "secrets/ovh/ddns-updater.json.age".publicKeys = allWithBackup;
  "secrets/immich/env.age".publicKeys = allWithBackup;
  "secrets/minecraft/rcon.age".publicKeys = allWithBackup;
}
