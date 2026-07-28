{ config, lib, ... }:

let
  domain = "heartblin.eu";

  # Service Matrix
  sm = {
    immich = { inherit (config.services.immich) enable port; };
  };
in {
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.caddy = {
    enable = true;
    virtualHosts = {
      "photos.${domain}" = lib.mkIf sm.immich.enable {
        useACMEHost = domain;
        extraConfig = ''
          reverse_proxy http://127.0.0.1:${toString sm.immich.port}
        '';
      };

      "${domain}" = {
        useACMEHost = domain;
        extraConfig = ''
          header Content-Type text/html

          respond <<HTML
          <!DOCTYPE html>
          <html>
          <head>
              <title>Testing</title>
          </head>
          <body>
              <h1>Hello World!</h1>
          </body>
          </html>
          HTML 200
        '';
      };
    };
  };
}
