{ lib, pkgs, ... }:

{
  users.users.primaryUser.extraGroups = [ "libvirtd" "kvm" ];
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
    };

    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
  };

  environment.systemPackages = [
    pkgs.winboat
    pkgs.podman-tui
    pkgs.podman-compose
  ];

  systemd.services = {
    libvirtd.wantedBy = lib.mkForce [ ];
    libvirt-guests.wantedBy = lib.mkForce [ ];
  };
}
