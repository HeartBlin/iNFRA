{ inputs, pkgs, ... }:

{
  imports = [ inputs.agenix.nixosModules.default ];
  environment.systemPackages = [ pkgs.ragenix pkgs.age ];
}
