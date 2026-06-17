{ config, ... }:

{
  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPorts = [ 443 ];
  };

  services.caddy = {
    enable = true;
    virtualHosts."http://, https://".extraConfig = "abort";
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "manea.emil@proton.me";
    certs."heartblin.eu" = {
      domain = "heartblin.eu";
      inherit (config.services.caddy) group;
      extraDomainNames = [ "*.heartblin.eu" ];
      dnsProvider = "ovh";
      credentialFiles = {
        "OVH_APPLICATION_KEY_FILE" = config.sops.secrets."ovh/app_key".path;
        "OVH_APPLICATION_SECRET_FILE" = config.sops.secrets."ovh/app_secret".path;
        "OVH_CONSUMER_KEY_FILE" = config.sops.secrets."ovh/consumer_key".path;
        "OVH_ENDPOINT_FILE" = config.sops.secrets."ovh/endpoint".path;
      };
    };
  };
}
