{ config, self, ... }:

let
  domain = "heartblin.eu";
  email = "manea.emil@mailbox.org";
in {
  age.secrets = {
    ovh-app-key = {
      file = "${self}/secrets/ovh/app-key.age";
      owner = "acme";
      group = config.services.caddy.group;
      mode = "0440";
    };

    ovh-app-secret = {
      file = "${self}/secrets/ovh/app-secret.age";
      owner = "acme";
      group = config.services.caddy.group;
      mode = "0440";
    };

    ovh-consumer-key = {
      file = "${self}/secrets/ovh/consumer-key.age";
      owner = "acme";
      group = config.services.caddy.group;
      mode = "0440";
    };

    ovh-endpoint = {
      file = "${self}/secrets/ovh/endpoint.age";
      owner = "acme";
      group = config.services.caddy.group;
      mode = "0440";
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults = { inherit email; };
    certs."${domain}" = {
      inherit (config.services.caddy) group;
      extraDomainNames = [ "*.${domain}" ];
      dnsProvider = "ovh";
      credentialFiles = {
        "OVH_APPLICATION_KEY_FILE" = config.age.secrets.ovh-app-key.path;
        "OVH_APPLICATION_SECRET_FILE" = config.age.secrets.ovh-app-secret.path;
        "OVH_CONSUMER_KEY_FILE" = config.age.secrets.ovh-consumer-key.path;
        "OVH_ENDPOINT_FILE" = config.age.secrets.ovh-endpoint.path;
      };
    };
  };
}
