{pkgs, lib, ...}: {
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-kde
    ];
  };

  environment.pathsToLink = ["/libexec"]; # links /libexec from derivations to /run/current-system/sw

  services = {
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
    xserver = {
      enable = true;
      desktopManager.plasma5.enable = true;
      displayManager = {
        gdm = {
          enable = true;
          wayland = false;
        };
      };
    };
  };

  programs = {
    # monitor backlight control
    light.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    xsel
    hyprpicker  # color picker

    # audio
    alsa-utils # provides amixer/alsamixer/...
    # mpd # for playing system sounds
    # mpc-cli # command-line mpd client
    # ncmpcpp # a mpd client with a UI
    networkmanagerapplet # provide GUI app: nm-connection-editor
  ];

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    khelpcenter
    kmail
    konsole
    print-manager
  ];
}
