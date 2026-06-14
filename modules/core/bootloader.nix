_:

{
  boot = {
    initrd.systemd.enable = true;
    bootspec.enable = true;
    loader = {
      systemd-boot.enable = true;
      timeout = 0;
      efi.canTouchEfiVariables = true;
    };
  };
}
