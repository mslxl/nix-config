{config, ...}: {
  # gpg agent with pinentry
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = false;
  };
}
