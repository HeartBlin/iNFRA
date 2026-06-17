{ inputs, system, ... }:

let
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in
  builtins.readDir ./.
  |> pkgs.lib.filterAttrs (_: type: type == "directory")
  |> builtins.mapAttrs (name: _: pkgs.callPackage (./. + "/${name}") { })
