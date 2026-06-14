inputs:

let
  inherit (inputs.nixpkgs) lib;
in
  ./.
  |> lib.filesystem.listFilesRecursive
  |> (lib.filter (p: lib.hasSuffix ".nix" p && !lib.hasPrefix "_" (baseNameOf p)))
  |> (map (p: lib.nameValuePair (lib.removeSuffix ".nix" (baseNameOf p)) p))
  |> lib.listToAttrs
