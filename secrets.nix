let
  keys = import ./secrets/keys.nix;
  inherit (keys) Void Reason Finality;
in {
  # DNS
  "secrets/ovh/app-key.age".publicKeys = [ Void Reason Finality ];
  "secrets/ovh/app-secret.age".publicKeys = [ Void Reason Finality ];
  "secrets/ovh/consumer-key.age".publicKeys = [ Void Reason Finality ];
  "secrets/ovh/endpoint.age".publicKeys = [ Void Reason Finality ];

  # DDNS
  "secrets/ovh/ddns-updater.json.age".publicKeys = [ Void Reason Finality ];
}
