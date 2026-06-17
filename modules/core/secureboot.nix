{ inputs, lib, pkgs, ... }:

{
  imports = [ inputs.lanzaboote.nixosModules.default ];
  config = {
    environment.systemPackages = [ pkgs.sbctl ];
    boot = {
      loader.systemd-boot.enable = lib.mkForce false;
      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
        autoGenerateKeys.enable = true;
        autoEnrollKeys = {
          enable = true;
          autoReboot = true;
        };
      };
    };
  };
}
