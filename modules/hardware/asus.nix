_:

{
  boot.kernelParams = [ "i8042.nokbd" ];
  services = {
    supergfxd.enable = true;
    asusd.enable = true;
  };
}
