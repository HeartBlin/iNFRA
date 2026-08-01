{ config, inputs, lib, pkgs, ... }:

{
  documentation = {
    enable = false;
    doc.enable = false;
    info.enable = false;
    man.enable = false;
    nixos.enable = false;
  };

  nixpkgs.config = {
    allowAliases = false;
    allowBroken = false;
    allowUnfree = true;
    allowUnsupportedSystem = false;
    nvidia.acceptLicense = true;
  };

  nix = {
    package = pkgs.nixVersions.latest;
    channel.enable = false;
    nixPath = lib.mapAttrsToList (n: v: "${n}=${v.flake}") config.nix.registry;
    registry =
      inputs
      |> lib.filterAttrs (_: lib.isType "flake")
      |> (lib.mapAttrs (_: flake: { inherit flake; }));

    settings = {
      flake-registry = "";
      auto-optimise-store = true;
      allow-import-from-derivation = true;
      builders-use-substitutes = true;
      max-jobs = "auto";
      cores = 4;
      sandbox = true;
      sandbox-fallback = false;
      use-cgroups = true;
      use-xdg-base-directories = true;
      warn-dirty = false;
      experimental-features = [
        "cgroups"
        "flakes"
        "nix-command"
        "git-hashing"
        "verified-fetches"
        "pipe-operators"
      ];

      allowed-users = [ "@wheel" ];
      trusted-users = [ "@wheel" ];

      substituters = [
        "https://cache.nixos.org"
        "https://1nfr4.cachix.org"
      ];

      trusted-substituters = [
        "https://cache.nixos.org"
        "https://1nfr4.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "1nfr4.cachix.org-1:QFGiHAxVsOE7BP0OpwyhoMY5Kyv5h4M+MnrH9UyY9Wk="
      ];
    };
  };
}
