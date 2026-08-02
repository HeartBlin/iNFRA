{ config, lib, pkgs, self, ... }:

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

    # Services
    caddy
    ddns-updater
    immich
    jellyfin
    openssh
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
  ## This might downgrade the kernel sometimes
  networking.hostId = "42c3b839"; # Whatever
  boot = let
    latest = lib.last (
      lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
        builtins.attrValues (lib.filterAttrs (
            name: kernelPackages:
              (builtins.match "linux_[0-9]+_[0-9]+" name)
              != null
              && (builtins.tryEval kernelPackages).success
              && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
          )
          pkgs.linuxKernel.packages)
      )
    );
  in {
    supportedFilesystems = [ "zfs" ];
    kernelPackages = latest;
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
