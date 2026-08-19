{ lib, pkgs, ... }:

{
  security = {
    run0 = {
      enable = true;
      sudo-shim = {
        enable = true;
        package = pkgs.writeShellScriptBin "sudo" ''
          exec ${lib.getExe' pkgs.run0-sudo-shim "sudo"} --run0-extra-arg=--background= "$@"
        '';
      };

      persistentAuth = {
        enable = true;
        enableRemote = true;
      };
    };

    polkit = {
      enable = true;
      settings.Polkitd.ExpirationSeconds = 30;
    };

    sudo.enable = false;
    wrappers = {
      su.enable = lib.mkForce false;
      sudoedit.enable = lib.mkForce false;
      sg.enable = lib.mkForce false;
      pkexec.enable = lib.mkForce false;
      newgrp.enable = lib.mkForce false;
    };
  };
}
