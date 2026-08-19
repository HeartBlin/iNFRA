{ pkgs }:

let
  inherit (pkgs) fetchurl;
in {
  jars = {
    fabric-api = fetchurl {
      url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/3gT0I5vt/fabric-api-0.156.0%2B26.2.jar";
      hash = "sha256-jeGNn2qKKlshIO+ei/+3nMm3WYnAwCLDnJ38G8Oimpk=";
    };

    c2me = fetchurl {
      url = "https://cdn.modrinth.com/data/VSNURh3q/versions/HBLtzvqv/c2me-fabric-mc26.2-0.4.2-alpha.0.35.jar";
      hash = "sha256-RRu5ox8AUGkQSUZExmnWY9gJsYdQswKTkMnK6OfYL2k=";
    };

    ferrite-core = fetchurl {
      url = "https://cdn.modrinth.com/data/uXXizFIs/versions/d5ddUdiB/ferritecore-9.0.0-fabric.jar";
      hash = "sha256-ITlmxy7ZZ6zHOSvrKKhm+6MB/1a5l2wueAHC233mvyI=";
    };

    kotlin = fetchurl {
      url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/bdhiINYC/fabric-language-kotlin-1.13.13%2Bkotlin.2.4.10.jar";
      hash = "sha256-NMzazxO7k1H+Q85hkSwuCbcjZOQ+eH02uj0tBN7HWlI=";
    };

    lithium = fetchurl {
      url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/f7vZ0VWU/lithium-fabric-0.25.3%2Bmc26.2.jar";
      hash = "sha256-/d6S4jjoB1+JrX9wHyo9WFSviLqaZ2VxhKRAexBKxWM=";
    };

    noisium = fetchurl {
      url = "https://cdn.modrinth.com/data/hasdd01q/versions/rWMnuBfv/noisium-fabric-2.8.5%2Bmc26.2-pre-2.jar";
      hash = "sha256-15IPQuE0GHvM20d4XJI8kcaOg7dQeuEuYS3fsU7gePU=";
    };

    veinminer = fetchurl {
      url = "https://cdn.modrinth.com/data/OhduvhIc/versions/3n61YghU/veinminer-fabric-2.11.2.jar";
      hash = "sha256-jpicZKd6+yNTR//LvI5v0aCovNlt5SvH0+S8YCVoXtk=";
    };
  };

  configs = {
    "Veinminer/settings.json" = ./config/Veinminer/settings.json;
    "Veinminer/groups.json" = ./config/Veinminer/groups.json;
  };
}
