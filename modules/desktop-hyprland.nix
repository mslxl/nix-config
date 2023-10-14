{pkgs, hyprland, ...}: {
  
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
    ];
  };

  environment.pathsToLink = ["/libexec"]; # links /libexec from derivations to /run/current-system/sw
  services = {
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
    xserver = {
      enable = true;

      desktopManager = {
        xterm.enable = false;
      };

      displayManager = {
        defaultSession = "hyprland";
        lightdm.enable = false;
        gdm = {
          enable = true;
          wayland = true;
        };
        # sddm.enable = true;
      };
    };
  };

  programs = {
    hyprland = {
      enable = true;
    
      xwayland = {
        enable = true;
      };
    
      enableNvidiaPatches = true;
    };

    # monitor backlight control
    light.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    waybar # the status bar
    swaybg # the wallpaper
    swayidle # the idle timeout
    swaylock # locking the screen
    wlogout # logout menu
    wl-clipboard # copying and pasting
    hyprpicker  # color picker

    wf-recorder # creen recording
    grim # taking screenshots
    slurp # selecting a region to screenshot

    dunst # the notification daemon, the same as dunst

    # audio
    alsa-utils # provides amixer/alsamixer/...
    # mpd # for playing system sounds
    # mpc-cli # command-line mpd client
    # ncmpcpp # a mpd client with a UI
    networkmanagerapplet # provide GUI app: nm-connection-editor
  ];

  # fix https://github.com/ryan4yin/nix-config/issues/10
  security.pam.services.swaylock = {};
}
