{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";

    systems = {
      type = "github";
      owner = "nix-systems";
      repo = "x86_64-linux";
    };
  };

  outputs = inputs: let
    inherit (inputs.nixpkgs) lib; # Get 'lib'
    systems = import inputs.systems; # Get 'systems'
    load = name: import (./. + "/${name}/_default.nix"); # Loads '_default.nix'

    # Map nicer names to output schema
    aliases = {
      clients = "nixosConfigurations";
      modules = "nixosModules";
    };
  in
    # Transform a list to the flake outputs
    lib.mapAttrs' (n: _: let
      out = aliases.${n} or n; # Check if we aliased a attribute
    in
      # Create key-value pair of the output
      lib.nameValuePair out (
        if builtins.elem out [ "formatter" "packages" ] # These need 'system'
        then lib.genAttrs systems (system: load n { inherit inputs system; }) # Give 'system'
        else load n inputs # No 'system' needed
      ))
    # Get CWD, filter out .git
    (builtins.readDir ./.
      |> lib.filterAttrs (n: v: v == "directory" && !lib.hasPrefix "." n));
}
