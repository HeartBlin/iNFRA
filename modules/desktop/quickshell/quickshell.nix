{ inputs, lib, pkgs, ... }:

{
  services.upower.enable = true;
  environment = {
    systemPackages = [ pkgs.quickshell ];
    etc = {
      "wallpapers".source = inputs.kantaiWalls;
      "xdg/quickshell".source = lib.cleanSourceWith {
        src = ./.;
        filter = path: _: baseNameOf path != "default.nix";
      };
    };
  };
}
