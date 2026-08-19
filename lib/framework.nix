inputs @ { self, ... }:

let
  inherit (inputs.nixpkgs) lib;

  # Get 'system'
  supportedSystems = import inputs.systems;
  forAllSystems = lib.genAttrs supportedSystems;

  # Folder structure
  checks = ./checks.nix;
  formatters = ./formatters.nix;
  hosts = ../clients;
  modules = ../modules;
  packages = ../packages;

  # For 'nix flake check'
  collectChecks = forAllSystems (system: import checks { inherit inputs system; });

  # For 'nix fmt'
  collectFormatters = forAllSystems (system: import formatters { inherit inputs system; });

  # Find all hosts
  collectHosts =
    lib.genAttrs (
      builtins.readDir ../clients
      |> lib.filterAttrs
      (n: v: v == "directory" && builtins.pathExists "${hosts}/${n}/config.nix")
      |> builtins.attrNames
    ) (host:
      lib.nixosSystem {
        specialArgs = { inherit inputs self; };
        modules = [ "${hosts}/${host}/config.nix" ];
      });

  # Find all modules
  collectModules =
    modules
    |> lib.filesystem.listFilesRecursive
    |> (lib.filter (p: lib.hasSuffix ".nix" p && !lib.hasPrefix "_" (baseNameOf p)))
    |> (map (p: lib.nameValuePair (lib.removeSuffix ".nix" (baseNameOf p)) p))
    |> lib.listToAttrs;

  # Find all packages
  collectPackages = forAllSystems (system: let
    pkgs = inputs.nixpkgs.legacyPackages.${system};
  in
    packages
    |> builtins.readDir
    |> lib.filterAttrs (_: type: type == "directory")
    |> builtins.mapAttrs (name: _: pkgs.callPackage "${packages}/${name}" { }));
in {
  checks = collectChecks;
  formatter = collectFormatters;
  nixosConfigurations = collectHosts;
  nixosModules = collectModules;
  packages = collectPackages;
}
