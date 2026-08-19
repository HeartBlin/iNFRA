_:

{
  networking = {
    wireguard.interfaces.wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 51820;
      privateKeyFile = "/etc/wireguard/private.key";

      peers = [
        {
          publicKey = "8PrXmK62578I5QfpfTRn27n6m6KNRkM2nWobmN/1aFg=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
      ];
    };

    firewall = {
      allowedUDPPorts = [ 51820 ];
      interfaces."wg0".allowedTCPPorts = [ 22 ];
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
