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

    # Security
    agenix
    run0

    # Services
    caddy
    ddns-updater
    immich
    jellyfin
    minecraft
    openssh
    restic
    scrutiny
    sftpgo
    uptime
    vaultwarden

    ./disko.nix
  ];

  ## Module Overriding
  # user.nix
  users.users.primaryUser = {
    name = "server";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFpgPRSO60dVRKcX04oyk/0TW+uSQwSlasKh4e87EMLy heartblin@Void"
    ];
  };

  # We use ZFS (not declared in Disko)
  networking.hostId = "42c3b839"; # Whatever
  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs.extraPools = [ "tank" ];
  };

  # I want fstrim & scrubbing
  services = {
    fstrim.enable = true;
    zfs.autoScrub.enable = true;
  };

  # I want Mesa
  hardware.graphics.enable = true;

  # System ID
  networking.hostName = "Reason";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.11";
}
