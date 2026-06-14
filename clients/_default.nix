inputs:

let
  inherit (inputs.nixpkgs) lib;

  # Find all hosts
  hosts =
    builtins.readDir ./. # CWD
    # Get all folders that have a config.nix file inside
    |> lib.filterAttrs
    (n: v: v == "directory" && builtins.pathExists (./. + "/${n}/config.nix"))
    # Make them attrs
    |> builtins.attrNames;
in
  # Iterate on every host
  lib.genAttrs hosts (
    host:
    # Declare the host
      lib.nixosSystem {
        specialArgs = { inherit (inputs) self; };
        modules = [ (./. + "/${host}/config.nix") ]; # Just the config.nix file
      }
  )
