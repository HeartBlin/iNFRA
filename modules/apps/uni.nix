{ config, pkgs, self, ... }:

{
  users.users.${config.kantai.user}.extraGroups = [ "dialout" ];
  environment.systemPackages = [
    self.packages.${pkgs.stdenv.system}.ltspice
  ];
}
