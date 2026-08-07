{ pkgs, ... }:

let
  mcVer = "26.2";
  fabricVer = "0.19.3";
  installerVer = "1.1.2";

  vanillaJar = pkgs.fetchurl {
    url = "https://piston-data.mojang.com/v1/objects/823e2250d24b3ddac457a60c92a6a941943fcd6a/server.jar";
    hash = "sha256-zazfsliY3l5LSw5d3MJyL3cGfkZgVwnC2IbAAOu2PsU=";
  };

  fabricJar = pkgs.fetchurl {
    url = "https://meta.fabricmc.net/v2/versions/loader/${mcVer}/${fabricVer}/${installerVer}/server/jar";
    hash = "sha256-MB+DqsNrI/K8ZMxYVg7fmFM8+qMOU68AK6lQx19BALQ=";
  };
in
  pkgs.writeShellApplication {
    name = "fabric-server";
    runtimeInputs = [ pkgs.openjdk25_headless ];
    text = ''
      exec java "$@" \
        -Dfabric.gameJarPath="${vanillaJar}" \
        -jar "${fabricJar}" \
        nogui
    '';
  }
