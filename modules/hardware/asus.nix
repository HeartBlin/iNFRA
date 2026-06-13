_:

{
  boot.kernelParams = [ "i8042.nokbd" ];
  services = {
    supergfxd.enable = true;
    asusd.enable = true;

    # My left arrow key is broken. Remap to right control
    udev.extraHwdb = ''
      evdev:input:b0003v0B05p1866*
        KEYBOARD_KEY_700e4=left
        KEYBOARD_KEY_70050=reserved
    '';
  };
}
