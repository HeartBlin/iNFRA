{
  disko.devices.disk.intel = {
    device = "/dev/disk/by-id/nvme-INTEL_SSDPEKNU512GZ_BTKA20450EZM512A";
    type = "disk";
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

        swap = {
          size = "24G";
          content = {
            type = "swap";
            discardPolicy = "both";
            resumeDevice = true;
          };
        };

        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "xfs";
            mountpoint = "/";
            mountOptions = [
              "defaults"
              "pquota"
            ];
          };
        };
      };
    };
  };
}
