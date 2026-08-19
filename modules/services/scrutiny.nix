{ inputs, ... }:

{
  services = {
    scrutiny = {
      enable = true;

      collector = {
        enable = true;
        schedule = "04:00,16:00";
      };

      settings.web.listen = {
        host = "127.0.0.1";
        port = 53417; # Bad attempt at "smart" in l33t5p34k
      };
    };

    caddy.virtualHosts."smart.${inputs.stigmata.constants.domain}".extraConfig = ''
      ${inputs.stigmata.constants.mTLS}
      reverse_proxy http://127.0.0.1:53417
    '';
  };
}
