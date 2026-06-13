{ inputs, pkgs, ... }:

{
  nixpkgs.config.cudaSupport = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  environment.systemPackages = [ pkgs.btop ];
  hardware = {
    nvidia = {
      branch = "bleeding_edge";
      package = inputs.chaotic.unrestrictedPackages.${pkgs.stdenv.system}.linuxPackages_cachyos.nvidiaPackages.mkDriver {
        version = "610.43.02";
        sha256_64bit = "sha256-MDSgVLtM33dS/43CclZMsQVROAS/9TU4lFkBsWyndGM=";
        sha256_aarch64 = "sha256-isWTnokUA/dzWocFBLalnk4+O5gSExVjs3dVpdYTU88=";
        openSha256 = "sha256-hP5NVZZ4vGsACHLmUDKq4uckpd/kn1GxCSYnnJfAuBs=";
        settingsSha256 = "sha256-0YAhufRgjDW+uR+kjaTb154fibpcDw8QowfrucoZsKE=";
        persistencedSha256 = "sha256-dObfc/suksLZr0CsU1GHtDJS2EeHO93eopkN2BLGklg=";
        patches = [ ];
      };

      open = true;
      gsp.enable = true;
      nvidiaSettings = false;
      powerManagement.enable = true;

      moduleParams.nvidia = {
        NVreg_EnableResizableBar = 1;
        NVreg_UsePageAttributeTable = 1;
        NVreg_EnableGpuFirmware = 0;
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

    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  boot = {
    kernelParams = [ "nvidia-drm.modeset=1" "nvidia-drm.fbdev=1" ];
    initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
  };
}
