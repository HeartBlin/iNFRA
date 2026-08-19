{ inputs, system }:

let
  pkgs = inputs.nixpkgs.legacyPackages.${system};
  inherit (inputs) self;
in
  pkgs.writeShellApplication {
    name = "format";
    runtimeInputs = [ self.packages.${system}.alejandra-custom pkgs.deadnix pkgs.statix ];
    text = ''
      deadnix --edit "$@"
      statix fix "$@"
      alejandra "$@"
    '';
  }
