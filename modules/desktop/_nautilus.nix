{ config, pkgs, self, ... }:

{
  environment.systemPackages = with pkgs; [
    nautilus
    sushi
    nautilus-python

    self.packages.${pkgs.stdenv.system}.nautilus-my-computer
  ];

  hjem.users.primaryUser.files.".config/gtk-3.0/bookmarks".text = ''
    file:///home/${config.users.users.primaryUser.name}/Documents Documents
    file:///home/${config.users.users.primaryUser.name}/Downloads Downloads
    file:///home/${config.users.users.primaryUser.name}/Music Music
    file:///home/${config.users.users.primaryUser.name}/Pictures Pictures
    file:///home/${config.users.users.primaryUser.name}/Projects Projects
    file:///home/${config.users.users.primaryUser.name}/Videos Videos
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
