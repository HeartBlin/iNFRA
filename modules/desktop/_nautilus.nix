{ config, pkgs, self, ... }:

{
  environment.systemPackages = with pkgs; [
    nautilus
    sushi
    nautilus-python
    self.packages.${pkgs.stdenv.system}.nautilus-taildrop
  ];

  hjem.users.primaryUser.files.".config/gtk-3.0/bookmarks".text = ''
    file:///home/${config.users.users.primaryUser.name}/Projects Projects
    smb://heartblin.eu/Media Media
    smb://heartblin.eu/Private Private
  '';

  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/nautilus/icon-view".captions = [
        "size"
        "none"
        "none"
      ];
    }
  ];
}
