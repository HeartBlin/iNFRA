{ config, pkgs, lib, ... }:

let
  renderNode = "/dev/dri/by-path/pci-0000:06:00.0-render";
  waydroid = "${config.virtualisation.waydroid.package}/bin/waydroid";
in {
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };

  systemd.services = {
    waydroid-container = {
      wantedBy = lib.mkForce [ ];
      serviceConfig = {
        Delegate = true;
        CPUAccounting = true;
        MemoryAccounting = true;
        TaskAccounting = true;
        ExecStartPre = lib.mkAfter [
          (pkgs.writeShellScript "waydroid-gpu-fix-pre" ''
            set -e
            PROP_FILE="/var/lib/waydroid/waydroid.prop"

            mkdir -p /var/lib/waydroid
            touch "$PROP_FILE"
            chown root:root "$PROP_FILE"
            chmod 644 "$PROP_FILE"

            set_prop() {
              ${pkgs.gnused}/bin/sed -i "/^$1=/d" "$PROP_FILE"
              echo "$1=$2" >> "$PROP_FILE"
            }

            set_prop ro.hardware.gralloc gbm
            set_prop ro.hardware.egl mesa
            set_prop gralloc.gbm.device ${renderNode}
            set_prop ro.hardware.vulkan amdgpu
            set_prop persist.waydroid.width 1920
            set_prop persist.waydroid.height 1080
            set_prop persist.waydroid.multi_windows true

            # Clean empty lines
            ${pkgs.gnused}/bin/sed -i '/^$/d' "$PROP_FILE"
          '')
        ];
      };
    };

    waydroid-gpu-persistence = {
      description = "Enforce GPU for Waydroid (Post-Start Backup)";
      after = [ "waydroid-container.service" ];
      bindsTo = [ "waydroid-container.service" ];
      wantedBy = [ "waydroid-container.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "waydroid-fix-post" ''
          set -e
          ${pkgs.coreutils}/bin/sleep 5
          ${waydroid} prop set ro.hardware.gralloc gbm
          ${waydroid} prop set ro.hardware.egl mesa
          ${waydroid} prop set gralloc.gbm.device ${renderNode}
          ${waydroid} prop set ro.hardware.vulkan amdgpu
          ${waydroid} prop set persist.waydroid.width 1920
          ${waydroid} prop set persist.waydroid.height 1080
          ${waydroid} prop set persist.waydroid.multi_windows true
        '';
      };
    };
  };
}
