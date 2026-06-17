{ lib, pkgs, ... }:

{
  security.pam.services = {
    login.enableGnomeKeyring = true;
    greetd.enableGnomeKeyring = true;
  };

  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${lib.getExe pkgs.tuigreet} --time --remember --remember-session";
          user = "greeter";
        };
      };
    };
  };
}
