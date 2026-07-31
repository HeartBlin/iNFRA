_:

let
  inherit (import ./_helper.nix) domain mTLS;
in {
  services = {
    uptime-kuma = {
      enable = true;
      appriseSupport = true;
      settings.PORT = "3001";
    };

    caddy.virtualHosts."uptime.${domain}".extraConfig = ''
      ${mTLS}
      reverse_proxy http://127.0.0.1:3001
    '';
  };
}
