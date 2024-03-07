{
  config,
  lib,
  pkgs,
  ...
}: {
  # fix for `sudo xxx` in kitty/wezterm and other modern terminal emulators
  security.sudo.keepTerminfo = true;

  services = {
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
  };

  programs = {
    # The OpenSSH agent remembers private keys for you
    # so that you don’t have to type in passphrases every time you make an SSH connection.
    # Use `ssh-add` to add a key to the agent.
    ssh.startAgent = true;
    # dconf is a low-level configuration system.
    dconf.enable = true;

    # thunar file manager(part of xfce) related options
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };
}
