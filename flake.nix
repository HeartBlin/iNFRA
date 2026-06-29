{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    systems.url = "github:nix-systems/x86_64-linux";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    kantaiWalls = {
      url = "git+ssh://git@github.com/HeartBlin/KantaiWalls.git";
      flake = false; # Literally just PNGs
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit.follows = "";
      };
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
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

    # Ignored folders
    ignore = [ "secrets" ];
  in
    # Transform a list to the flake outputs
    lib.mapAttrs' (n: _: let
      out = aliases.${n} or n; # Check if we aliased a attribute
    in
      # Create key-value pair of the output
      lib.nameValuePair out (
        if builtins.elem out [ "checks" "formatter" "packages" ] # These need 'system'
        then lib.genAttrs systems (system: load n { inherit inputs system; }) # Give 'system'
        else load n inputs # No 'system' needed
      ))
    # Get CWD, filter out .git
    (builtins.readDir ./.
      |> lib.filterAttrs (n: v:
        v
        == "directory"
        && !lib.hasPrefix "." n
        && !(builtins.elem n ignore)));
}
