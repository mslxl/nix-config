# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL
{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  hostName = "nixos-wsl";
in {
  wsl = {
    enable = true;
    defaultUser = username;
    wslConf = {
      automount.root = "/mnt";
      interop.appendWindowsPath = true;
    };
    startMenuLaunchers = false;
  };

  hardware.graphics.enable = true;

  networking = {
    inherit hostName;
    firewall.enable = false;
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  nix.settings.substituters = [
    "https://mirror.sjtug.edu.cn/nix-channels/store"
    "https://mirrors.ustc.edu.cn/nix-channels/store"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
