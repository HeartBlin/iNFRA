{ config, ... }:

{
  services.scrutiny = {
    enable = true;
    collector.enable = true;
    settings.web.listen = {
      host = "127.0.0.1";
      port = 8067;
    };
  };

  services.caddy.virtualHosts."scrutiny.heartblin.eu" = {
    useACMEHost = "heartblin.eu";
    extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.scrutiny.settings.web.listen.port}
    '';
  };
}
