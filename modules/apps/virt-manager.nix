{ pkgs, ... }:

{
  users.users.primaryUser.extraGroups = [ "libvirt" ];
  programs.virt-manager.enable = true;
  environment.systemPackages = [ pkgs.dnsmasq ];
  networking.firewall.trustedInterfaces = [ "virbr0" ];
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        vhostUserPackages = [ pkgs.virtiofsd ];
      };
    };
  };
}
