{ self, ... }:

{
  imports = [
    self.nixosModules.bootloader
  ];

  # System ID
  networking.hostName = "Void";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.05";
}
