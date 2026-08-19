{ config, inputs, lib, pkgs, self, ... }:

let
  serverDir = "/mnt/storage/minecraft";
  publicPort = 25565;
  internalPort = 25566;
  rconPort = 25575;

  fabricServer = self.packages.${pkgs.stdenv.system}.fabric-server;
  jvmParams = builtins.concatStringsSep " " [
    "-XX:+UseZGC"
    "-XX:+UseCompactObjectHeaders"
    "-Xmx6G"
    "-Xms6G"
  ];

  inherit (inputs.stigmata.constants) ops whitelist;
  opsFile = pkgs.writeText "ops.json" ops;
  whitelistFile = pkgs.writeText "whitelist.json" whitelist;

  baseProperties = {
    gamemode = "survival";
    difficulty = "normal";
    enable-code-of-conduct = false;
    enforce-secure-profile = false;
    max-players = 5;
    white-list = true;

    server-port = internalPort;
    server-ip = "127.0.0.1";
    enable-rcon = true;
    "rcon.port" = rconPort;
  };

  proprietiesBase = pkgs.writeText "server.properties.base" (
    lib.generators.toKeyValue {
      mkKeyValue = lib.generators.mkKeyValueDefault { } "=";
    }
    baseProperties
  );

  lazymcConfigBase = (pkgs.formats.toml { }).generate "lazymc.toml.base" {
    advanced.rewrite_server_properties = false;
    config.version = "0.2.11";
    public = {
      address = "0.0.0.0:${toString publicPort}";
      version = "26.2";
      protocol = 769;
    };

    server = {
      directory = serverDir;
      address = "127.0.0.1:${toString internalPort}";
      command = "${lib.getExe fabricServer} ${jvmParams}";
      start_timeout = 300;
      stop_timeout = 60;
      freeze_process = false;
      wake_whitelist = true;
    };

    rcon = {
      enabled = true;
      port = rconPort;
      randomize_password = false;
      password = "@RCON_PASSWORD@";
    };
  };

  modData = import ./_mods.nix { inherit pkgs; };
  mods = pkgs.linkFarm "fabric-mods" (
    lib.mapAttrsToList (name: path: {
      name = "${name}.jar";
      inherit path;
    })
    modData.jars
  );

  linkConfigs = builtins.concatStringsSep "\n" (
    lib.mapAttrsToList (filepath: storePath: ''
      mkdir -p "$(dirname "${serverDir}/config/${filepath}")"
      ln -sfn ${storePath} "${serverDir}/config/${filepath}"
    '')
    modData.configs
  );
in {
  age.secrets.mc-rcon = {
    file = "${inputs.stigmata}/secrets/minecraft/rcon.age";
    owner = "minecraft";
    group = "minecraft";
    mode = "0440";
  };

  users = {
    groups.minecraft = { };
    users.minecraft = {
      description = "Minecraft server service user";
      createHome = false;
      isSystemUser = true;
      group = "minecraft";
    };
  };

  networking.firewall.allowedTCPPorts = [ publicPort ];
  systemd.services.fabric-server = {
    description = "Fabric Server + LazyMC";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "minecraft";
      Group = "minecraft";

      WorkingDirectory = serverDir;
      ExecStartPre = [
        "+${pkgs.writeShellScript "fabric-init-dir" ''
          mkdir -p ${serverDir}
          chown minecraft:minecraft ${serverDir}
        ''}"

        (pkgs.writeShellScript "fabric-pre-start" ''
          set -euo pipefail
          echo "eula=true" > ${serverDir}/eula.txt

          cp --remove-destination ${opsFile} ${serverDir}/ops.json
          chmod 600 ${serverDir}/ops.json

          cp --remove-destination ${whitelistFile} ${serverDir}/whitelist.json
          chmod 600 ${serverDir}/whitelist.json

          rm -rf ${serverDir}/mods
          ln -sfn ${mods} ${serverDir}/mods
          ${linkConfigs}

          cp -f ${proprietiesBase} ${serverDir}/server.properties
          chmod 600 ${serverDir}/server.properties

          password="$(cat ${config.age.secrets.mc-rcon.path} | tr -d '\n')"
          echo "rcon.password=$password" >> ${serverDir}/server.properties

          sed "s|@RCON_PASSWORD@|$password|" ${lazymcConfigBase} > ${serverDir}/lazymc.toml
          chmod 600 ${serverDir}/lazymc.toml
        '')
      ];

      ExecStart = "${lib.getExe' pkgs.lazymc "lazymc"} --config ${serverDir}/lazymc.toml start";
      Restart = "on-failure";

      ReadWritePaths = [ serverDir ];

      ProtectHome = true;
      ProtectSystem = "strict";
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectKernelTunables = true;
      ProtectControlGroups = true;
      RestrictRealtime = true;
    };
  };
}
