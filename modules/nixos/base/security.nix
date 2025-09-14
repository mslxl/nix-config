{
  config,
  pkgs,
  ...
}:
{
  programs.ssh.startAgent = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
    settings.default-cache-ttl = 4 * 60 * 60; # 4 hours
  };
}
