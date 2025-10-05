{config, ...}: let
  hostName = "aquamarine";
in {
  # programs.ssh.matchBlocks."github.com".identityFile =
  #   "${config.home.homeDirectory}/.ssh/${hostName}";
}
