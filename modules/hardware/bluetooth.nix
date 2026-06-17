_:

{
  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings.General.Experimental = true;
  };
}
