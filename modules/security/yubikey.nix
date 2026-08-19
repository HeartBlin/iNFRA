_:

{
  security.pam = {
    u2f = {
      enable = true;
      settings.cue = true;
    };

    services = {
      login.u2fAuth = true;
      polkit-1.u2fAuth = true;
    };
  };
}
