{config, ...}: {
  # gpg agent with pinentry
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };
}
