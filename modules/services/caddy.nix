_:

let
  domain = "heartblin.eu";
in {
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.caddy = {
    enable = true;
    virtualHosts."${domain}" = {
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
}
