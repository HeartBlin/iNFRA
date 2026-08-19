{ pkgs, ... }:

pkgs.rustPlatform.buildRustPackage {
  pname = "alejandra";
  version = "4.0.0-custom";
  src = builtins.fetchGit {
    url = "https://github.com/kamadorueda/alejandra.git";
    rev = "8f47c5e82ee8e6e8adcc1748be0056a1e349f7e8";
    ref = "main";
  };

  patches = [ ./adblock.patch ./style.patch ];
  cargoHash = "sha256-IX4xp8llB7USpS/SSQ9L8+17hQk5nkXFP8NgFKVLqKU=";
  doCheck = false;

  meta = with pkgs.lib; {
    description = "The Uncompromising Nix Code Formatter (Patched)";
    homepage = "https://github.com/kamadorueda/alejandra";
    license = licenses.unlicense;
    mainProgram = "alejandra";
  };
}
