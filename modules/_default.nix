inputs:

let
  inherit (inputs.nixpkgs) lib;
in
  ./. # All files
  # Filter for files
  |> lib.filesystem.listFilesRecursive
  # Get only the '.nix', non '_' prefixed files
  |> (lib.filter (p: lib.hasSuffix ".nix" p && !lib.hasPrefix "_" (baseNameOf p)))
  # Remove the '.nix' suffix
  |> (map (p: lib.nameValuePair (lib.removeSuffix ".nix" (baseNameOf p)) p))
  # Build the attribute set
  |> lib.listToAttrs
