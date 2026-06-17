{ config, ... }:

{
  programs.git = {
    enable = true;
    config = {
      commit.gpgSign = true;
      gpg.format = "ssh";
      user.signingkey = "${config.users.users.primaryUser.home}/.ssh/GitHubSign";
    };
  };
}
