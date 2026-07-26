{ pkgs, self, ... }:

{
  imports = with self.nixosModules; [
    # Apps
    chromium
    gaming
    git
    nh
    shell
    ssh
    uni
    virt-manager
    vscodium
    waydroid

    # Core
    bootloader
    disko
    i18n
    networking
    nix
    plymouth
    secureboot
    user
    zram

    # Desktop
    gnome

    # Hardware
    amd
    asus
    audio
    bluetooth
    nvidia

    # Security
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
  programs.nh.flake = "/home/heartblin/Projects/infra";

  # nvidia.nix
  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:1@0:0:0";
    amdgpuBusId = "PCI:6@0:0:0";
    offload = {
      enable = true;
      enableOffloadCmd = true;
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
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelModules = [ "kvm-amd" ];
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices = {
        "crypt-samsung".crypttabExtraOpts = [ "fido2-device=auto" ];
        "crypt-intel".crypttabExtraOpts = [ "fido2-device=auto" ];
      };
    };
  };

  # System ID
  networking.hostName = "Void";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.11";
}
