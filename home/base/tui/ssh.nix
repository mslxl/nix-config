{config, ...}: {
  programs.ssh = {
    enable = true;

    # default config
    enableDefaultConfig = false;
    settings."*" = {
      ForwardAgent = false;
      # "a private key that is used during authentication will be added to ssh-agent if it is running"
      AddKeysToAgent = "yes";
      Compression = true;
      ServerAliveInterval = 0;
      ServerAliveCountMax = 3;
      HashKnownHosts = false;
      UserKnownHostsFile = "~/.ssh/known_hosts";
      ControlMaster = "no";
      ControlPath = "~/.ssh/master-%r@%n:%p";
      ControlPersist = "no";
      SetEnv = {
        TERM = "xterm-256color";
      };
    };

    settings."github.com" = {
      # "Using SSH over the HTTPS port for GitHub"
      # "(port 22 is banned by some proxies / firewalls)"
      HostName = "ssh.github.com";
      Port = 443;
      User = "git";

      # Specifies that ssh should only use the identity file explicitly configured above
      # required to prevent sending default identity files first.
      IdentitiesOnly = true;
    };
  };
}
