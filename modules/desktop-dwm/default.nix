{ config, pkgs, ... }:
let 
  dwm = pkgs.callPackage ./dwm.derv.nix {};
in {

  xdg.portal = {
    enable = true;
  };

  environment.pathsToLink = ["/libexec"]; # links /libexec from derivations to /run/current-system/sw

  services = {
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
    xserver = {
      enable = true;
      windowManager.dwm.enable = true;
      windowManager.dwm.package = dwm;
      displayManager = {
        gdm = {
          enable = true;
          wayland = false;
        };
      };
      libinput = {
        enable = true;
        touchpad = {
          naturalScrolling = true; 
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
    scrot
    hyprpicker  # color picker

    # audio
    alsa-utils # provides amixer/alsamixer/...
    # mpd # for playing system sounds
    # mpc-cli # command-line mpd client
    # ncmpcpp # a mpd client with a UI
    networkmanagerapplet # provide GUI app: nm-connection-editor

    dunst
    libnotify
    i3lock-fancy
  ];
}