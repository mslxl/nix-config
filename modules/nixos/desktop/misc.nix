{
  config,
  lib,
  pkgs,
  myvars,
  ...
}: {
  # fix for `sudo xxx` in kitty/wezterm and other modern terminal emulators
  security.sudo.keepTerminfo = true;

  # systemd.services.nix-daemon.serviceConfig = {
  #   # WARNING: THIS makes nix-daemon build extremely slow
  #   LimitNOFILE = lib.mkForce ;
  # };
  security.pam.loginLimits = [
    {
      domain = "*";
      item = "nofile";
      type = "-";
      value = "32768";
    }
    {
      domain = "*";
      item = "memlock";
      type = "-";
      value = "32768";
    }
  ];

  services = {
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
  };

  programs = {
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
