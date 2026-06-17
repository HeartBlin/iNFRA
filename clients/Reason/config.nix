{ pkgs, self, ... }:

{
  imports = with self.nixosModules; [
    # Apps
    nh
    shell

    # Core
    bootloader
    disko
    i18n
    networking
    nix
    secureboot
    user
    zram

    # Hardware
    intel

    # Security
    sudo

    # Services
    backup
    caddy
    immich
    jellyfin
    openssh
    samba
    scrutiny
    tailscale
    vaultwarden

    ./disko.nix
    ./secrets.nix
  ];

  ## Module Overriding
  # user.nix
  users.users.primaryUser = {
    name = "server";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEISJfRd1QeAC48Vkd4gNLZj9bPnmXDal2F9rc+3V9oI heartblin@Void"
    ];
  };

  ## Host Specifics
  # I want fstrim
  services.fstrim.enable = true;

  # Kernel things
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "libata.noacpi=1"
      "nowatchdog"
      "reboot=pci"
      "consoleblank=60"
    ];
  };

  # System ID
  networking.hostName = "Void";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.05";
}
