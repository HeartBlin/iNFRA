{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    systems.url = "github:nix-systems/x86_64-linux";

    # Declarative partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Basic home management
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secureboot
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit.follows = "";
      };
    };

    # command-not-found, but good
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        darwin.follows = "";
        home-manager.follows = "";
        systems.follows = "systems";
      };
    };
  };

  outputs = inputs @ { self, nixpkgs, systems, ... }: let
    inherit (nixpkgs) lib;
    supportedSystems = import systems;
    forAllSystems = lib.genAttrs supportedSystems;
  in {
    nixosConfigurations = import ./clients { inherit inputs self; };
    nixosModules = import ./modules { inherit inputs; };
    packages = forAllSystems (system: import ./packages { inherit inputs system; });
    checks = forAllSystems (system: import ./checks.nix { inherit inputs system; });
  };
}
