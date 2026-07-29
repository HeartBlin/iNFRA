{ config, lib, pkgs, self, ... }:

let
  domain = "heartblin.eu";

  # Service Matrix
  sm = {
    immich = { inherit (config.services.immich) enable port; };
    vaultwarden = {
      inherit (config.services.vaultwarden) enable;
      port = config.services.vaultwarden.config.ROCKET_PORT;
    };
  };

  # mTLS helper
  mtls = ''
    tls {
      client_auth {
        mode require_and_verify
        trust_pool file {
          pem_file /etc/caddy/root.pem
        }
      }
    }
  '';
in {
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
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/ovh@v1.1.0" ];
      hash = "sha256-/xpTqYydmJEthBgGJ3uZ9FDF19dlvWs0h8XUf8KkS/M=";
    };

    globalConfig = ''
      acme_dns ovh {
        endpoint {$OVH_ENDPOINT}
        application_key {$OVH_APPLICATION_KEY}
        application_secret {$OVH_APPLICATION_SECRET}
        consumer_key {$OVH_CONSUMER_KEY}
      }
    '';

    virtualHosts = {
      "photos.${domain}".extraConfig = lib.mkIf sm.immich.enable ''
        ${mtls}
        reverse_proxy http://127.0.0.1:${toString sm.immich.port}
      '';

      "vault.${domain}".extraConfig = lib.mkIf sm.vaultwarden.enable ''
        ${mtls}
        reverse_proxy http://127.0.0.1:${sm.vaultwarden.port} {
          header_up X-Real-IP {remote_host}
        }
      '';

      "${domain}".extraConfig = ''
         ${mtls}
        respond "Hello World!"
      '';
    };
  };
}
