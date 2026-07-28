{ self, ... }:

{
  imports = with self.nixosModules; [
    # Apps
    nh
    shell

    # Core
    bootloader
    disko
    networking
    nix
    secureboot
    user

    # Hardware
    amd

    # Services
    openssh

    ./disko.nix
  ];

  ## Module Overriding
  # user.nix
  users.users.primaryUser = {
    name = "server";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIILBPjrPeKOH2kJLKU634wVC/e3dndCGijZv0gaz997F heartblin@Void"
    ];
  };

  # I want fstrim
  services.fstrim.enable = true;

  # System ID
  networking.hostName = "Reason";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.11";
}
