{ config, ... }:

{
  programs.ssh.extraConfig = ''
    Host github.com
      HostName github.com
      User git
      IdentityFile ${config.users.users.primaryUser.home}/.ssh/GitHubAuth
      IdentitiesOnly yes

    Host Reason
      HostName 10.0.1.1
      Port 22
      User server
      IdentityFile ${config.users.users.primaryUser.home}/.ssh/Reason
      IdentitiesOnly yes
  '';
}
