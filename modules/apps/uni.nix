{ pkgs, ... }:

{
  users.users.primaryUser.extraGroups = [ "dialout" ];
  environment.systemPackages = [ pkgs.kicad ];
}
