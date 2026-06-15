{ self, ... }:

{
  imports = with self.nixosModules; [
    # Apps
    chromium

    # Core
    bootloader
    secureboot
    user
  ];

  # user.nix
  users.users.primaryUser = {
    name = "heartblin";
    description = "HeartBlin";
  };

  ### TESTING - VM - TESTING ###
  services.displayManager.defaultSession = "xfce";
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
  };

  virtualisation.vmVariant.virtualisation = {
    memorySize = 8192;
    cores = 8;
  };

  # System ID
  networking.hostName = "Void";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.05";
}
