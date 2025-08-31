{config, ...}: {
  programs.ssh = {
    enable = true;

    # "a private key that is used during authentication will be added to ssh-agent if it is running"
    addKeysToAgent = "yes";

    matchBlocks = {
      "github.com" = {
        # "Using SSH over the HTTPS port for GitHub"
        # "(port 22 is banned by some proxies / firewalls)"
        hostname = "ssh.github.com";
        port = 443;
        user = "git";

        # Specifies that ssh should only use the identity file explicitly configured above
        # required to prevent sending default identity files first.
        identitiesOnly = true;
      };
    };
  };
}
