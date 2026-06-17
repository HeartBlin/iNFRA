{ lib, ... }:

{
  networking = {
    nftables.enable = true;
    networkmanager = {
      enable = true;
      plugins = lib.mkForce [ ];
    };
  };

  boot = {
    kernelModules = [ "tcp_bbr" ];
    kernel.sysctl = {
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "fq";
    };
  };
}
