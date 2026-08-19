{ inputs, ... }:

{
  services = {
    uptime-kuma = {
      enable = true;
      appriseSupport = true;
      settings.PORT = "3001";
    };

    caddy.virtualHosts."uptime.${inputs.stigmata.constants.domain}".extraConfig = ''
      ${inputs.stigmata.constants.mTLS}
      reverse_proxy http://127.0.0.1:3001
    '';
  };
}
