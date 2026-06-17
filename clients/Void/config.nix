{ inputs, pkgs, self, ... }:

{
  imports = with self.nixosModules; [
    # Apps
    chromium
    foot
    gaming
    git
    nh
    shell
    ssh
    vscodium
    waydroid
    winboat

    # Core
    bootloader
    disko
    i18n
    networking
    nix
    quietboot
    secureboot
    user
    zram

    # Desktop
    fonts
    greetd
    hyprland
    quickshell
    rofi
    theme

    # Hardware
    amd
    asus
    audio
    bluetooth
    nvidia

    # Security
    sudo
    yubikey

    # Services
    tailscale

    ./disko.nix
  ];

  ## Module Overriding
  # git.nix
  programs.git.config.user = {
    name = "HeartBlin";
    email = "161874560+HeartBlin@users.noreply.github.com";
  };

  # nh.nix
  programs.nh.flake = "/home/heartblin/Projects/Kantai";

  # nvidia.nix
  hardware.nvidia = {
    package = inputs.chaotic.unrestrictedPackages.${pkgs.stdenv.system}.linuxPackages_cachyos.nvidiaPackages.mkDriver {
      version = "610.43.02";
      sha256_64bit = "sha256-MDSgVLtM33dS/43CclZMsQVROAS/9TU4lFkBsWyndGM=";
      sha256_aarch64 = "sha256-isWTnokUA/dzWocFBLalnk4+O5gSExVjs3dVpdYTU88=";
      openSha256 = "sha256-hP5NVZZ4vGsACHLmUDKq4uckpd/kn1GxCSYnnJfAuBs=";
      settingsSha256 = "sha256-0YAhufRgjDW+uR+kjaTb154fibpcDw8QowfrucoZsKE=";
      persistencedSha256 = "sha256-dObfc/suksLZr0CsU1GHtDJS2EeHO93eopkN2BLGklg=";
      patches = [ ];
    };

    prime = {
      nvidiaBusId = "PCI:1@0:0:0";
      amdgpuBusId = "PCI:6@0:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  # user.nix
  users.users.primaryUser = {
    name = "heartblin";
    description = "HeartBlin";
  };

  ## Host Specifics
  # My left arrow key is broken. Remap to right control, and disable it
  services.udev.extraHwdb = ''
    evdev:input:b0003v0B05p1866*
      KEYBOARD_KEY_700e4=left
      KEYBOARD_KEY_70050=reserved
  '';

  # I want fstrim
  services.fstrim.enable = true;

  # Some kernel changes
  boot = {
    kernelPackages = inputs.chaotic.legacyPackages.${pkgs.stdenv.system}.linuxPackages_cachyos-lto;
    resumeDevice = "/dev/mapper/crypted";
    kernelParams = [ "resume_offset=533760" "nowatchdog" ];
    extraModprobeConfig = "blacklist sp5100_tco"; # shush
  };

  # System ID
  networking.hostName = "Void";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.05";
}
