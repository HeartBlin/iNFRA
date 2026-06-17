{
  disko.devices = {
    disk = {
      samsung = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S4EWNX1W519812T";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings.allowDiscards = true;
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    "/swap" = {
                      mountpoint = "/.swapvol";
                      swap.swapfile.size = "32G"; # Double my RAM
                    };
                  };
                };
              };
            };
          };
        };
      };

      intel = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-INTEL_SSDPEKNU512GZ_BTKA20450EZM512A";
        content = {
          type = "gpt";
          partitions.xfs = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/mnt/intel";
              mountOptions = [ "defaults" "noatime" "pquota" ];
            };
          };
        };
      };
    };
  };
}
