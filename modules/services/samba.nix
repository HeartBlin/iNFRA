{ pkgs, config, ... }:

{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "security" = "user";
        "hosts allow" = "100. 10. localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };

      Media = {
        "path" = "/srv/samba/media";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = "smbuser";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "jellyfin";
        "force group" = "jellyfin";
      };

      Private = {
        "path" = "/srv/samba/private";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = "smbuser";
        "force user" = "smbuser";
        "force group" = "users";
        "create mask" = "0600";
        "directory mask" = "0700";
      };
    };
  };

  users.users."smbuser" = {
    description = "User to be used with Samba shares";
    group = "users";
    isSystemUser = true;
  };

  systemd.services.samba-provision-password = {
    description = "Declare Samba password via SOPS";
    wantedBy = [ "multi-user.target" ];
    after = [ "samba.service" ];
    requires = [ "samba-smbd.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      SMB_PASS=$(cat ${config.sops.secrets.samba.path})
      printf "$SMB_PASS\n$SMB_PASS\n" | ${pkgs.samba}/bin/smbpasswd -a -s smbuser
    '';
  };

  systemd.tmpfiles.rules = [
    "d /srv/samba/media 0755 jellyfin jellyfin -"
    "d /srv/samba/private 0700 smbuser smbuser -"
  ];
}
