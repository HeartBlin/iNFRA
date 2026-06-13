{
  outputs = { self, ... } @ inputs: {
    checks =
      import ./parts/checks.nix { inherit inputs self; };
    nixosConfigurations =
      import ./parts/clients.nix { inherit inputs self; };
    packages =
      import ./parts/packages.nix { inherit inputs; };
  };

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    systems.url = "github:nix-systems/x86_64-linux";

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs = {
        # nixpkgs.follows = "nixpkgs"; Cache
        home-manager.follows = "";
        jovian.follows = "";
        flake-schemas.follows = ""; # Detsys lmao
        rust-overlay.follows = "";
      };
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nix-darwin.follows = "";
      };
    };

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
}
