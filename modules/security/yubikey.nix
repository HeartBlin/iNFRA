_:

{
  boot.initrd.luks.devices."crypted".crypttabExtraOpts = [ "fido2-device=auto" ];
  security.pam = {
    u2f = {
      enable = true;
      settings.cue = true;
    };

    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
      polkit-1.u2fAuth = true;
    };
  };
}
