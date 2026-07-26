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

            luksSamsung = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypt-samsung";
                content = {
                  type = "lvm_pv";
                  vg = "pool";
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
          partitions.luksIntel = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypt-intel";
              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          };
        };
      };
    };

    lvm_vg.pool = {
      type = "lvm_vg";
      lvs = {
        swap = {
          size = "24G";
          content = {
            type = "swap";
            resumeDevice = true;
          };
        };

        root = {
          size = "100%FREE";
          content = {
            type = "filesystem";
            format = "xfs";
            mountpoint = "/";
            mountOptions = [ "defaults" "pquota" ];
          };
        };
      };
    };
  };
}
