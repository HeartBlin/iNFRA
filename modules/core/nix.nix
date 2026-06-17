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
      allow-import-from-derivation = false;
      builders-use-substitutes = true;
      max-jobs = "auto";
      cores = 0;
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
        "https://kantai.cachix.org"
        "https://nyx-cache.chaotic.cx"
        "https://hyprland.cachix.org"
      ];

      trusted-substituters = [
        "https://cache.nixos.org"
        "https://kantai.cachix.org"
        "https://nyx-cache.chaotic.cx"
        "https://hyprland.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "kantai.cachix.org-1:ldVeeaAtkCZs7BUSdLscSem+dX9wtqCT8cpks3HMFMk="
        "nyx-cache.chaotic.cx:dJxTrgMC3V3cFfyIiBQDQorG6k1LsqurH/srpMSq7qk="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };
}
