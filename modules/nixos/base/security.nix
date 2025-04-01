{config, ...}: {
  programs = {
    # The OpenSSH agent remembers private keys for you
    # so that you don’t have to type in passphrases every time you make an SSH connection.
    # Use `ssh-add` to add a key to the agent.
    ssh.startAgent = true;

    # gpg agent with pinentry
    gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
    };
  };
}
