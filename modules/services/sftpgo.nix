{ lib, ... }:

let
  inherit (import ./_helper.nix) domain mTLS;
in {
  services = {
    sftpgo = {
      enable = true;
      settings = {
        sftpd.bindings = [ { port = 0; } ];
        ftpd.bindings = [ { port = 0; } ];
        webdavd.bindings = [ { port = 0; } ];
        httpd.bindings = [
          {
            address = "127.0.0.1";
            port = 8090;
            enable_web_admin = true;
            enable_web_client = true;
          }
        ];
      };
    };

    caddy.virtualHosts."files.${domain}".extraConfig = ''
      ${mTLS}
      reverse_proxy http://127.0.0.1:8090 {
        header_up X-Real-IP {remote_host}
      }
    '';
  };

  systemd = {
    services.sftpgo.serviceConfig.UMask = lib.mkForce "0027";
    tmpfiles.rules = [
      "d /mnt/storage/media 2750 sftpgo media -"
    ];
  };
}
