{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [ pkgs.btop ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    nvidia = {
      branch = "bleeding_edge";
      open = true;
      gsp.enable = true;
      nvidiaSettings = false;
      powerManagement.enable = true;

      moduleParams.nvidia = {
        NVreg_EnableResizableBar = 1;
        NVreg_UsePageAttributeTable = 1;
        NVreg_EnableGpuFirmware = 0;
      };
    };

    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  boot.kernelParams = [ "nvidia-drm.modeset=1" "nvidia-drm.fbdev=1" ];
}
