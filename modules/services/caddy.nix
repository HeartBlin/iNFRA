{ config, pkgs, self, ... }:

{
  age.secrets.ovh-dns = {
    file = "${self}/secrets/ovh/dns.age";
    owner = config.services.caddy.group;
    group = config.services.caddy.group;
    mode = "0440";
  };

  systemd.services.caddy.serviceConfig.EnvironmentFile = [
    config.age.secrets.ovh-dns.path
  ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.caddy = {
    enable = true;
    enableReload = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/ovh@v1.1.0" ];
      hash = "sha256-/xpTqYydmJEthBgGJ3uZ9FDF19dlvWs0h8XUf8KkS/M=";
    };

    globalConfig = ''
      grace_period 15s
      acme_dns ovh {
        endpoint {$OVH_ENDPOINT}
        application_key {$OVH_APPLICATION_KEY}
        application_secret {$OVH_APPLICATION_SECRET}
        consumer_key {$OVH_CONSUMER_KEY}
      }
    '';
  };
}
