_:

let
  inherit (import ./_helper.nix) domain mTLS;
in {
  services = {
    scrutiny = {
      enable = true;

      collector = {
        enable = true;
        schedule = "0 */12 * * *";
      };

      settings.web.listen = {
        host = "127.0.0.1";
        port = 53417; # Bad attempt at "smart" in l33t5p34k
      };
    };

    caddy.virtualHosts."smart.${domain}".extraConfig = ''
      ${mTLS}
      reverse_proxy http://127.0.0.1:53417
    '';
  };
}
