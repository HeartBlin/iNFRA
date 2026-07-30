_:

{
  services.sftpgo = {
    enable = true;
    settings = {
      sftpd.bindings = [ { port = 0; } ];
      ftpd.bindings = [ { port = 0; } ];
      webdavd.bindings = [ { port = 0; } ];

      httpd.bindings = [
        {
          address = "127.0.0.1";
          port = 8090;
          enable_web_admin = true;
          enable_web_client = true;
        }
      ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /mnt/storage/media 0750 sftpgo sftpgo -"
  ];
}
