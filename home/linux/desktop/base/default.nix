{
  myutils,
  pkgs,
  config,
  ...
}: {
  imports = myutils.scanPaths ./.;

  # wayland related
  home.sessionVariables = {
    "NIXOS_OZONE_WL" = "1"; # for any ozone-based browser & electron apps to run on wayland
    "MOZ_ENABLE_WAYLAND" = "1"; # for firefox to run on wayland
    "MOZ_WEBRENDER" = "1";
    # enable native Wayland support for most Electron apps
    "ELECTRON_OZONE_PLATFORM_HINT" = "auto";
    # misc
    "_JAVA_AWT_WM_NONREPARENTING" = "1";
    "QT_WAYLAND_DISABLE_WINDOWDECORATION" = "1";
    "QT_QPA_PLATFORM" = "wayland";
    "SDL_VIDEODRIVER" = "wayland";
    "GDK_BACKEND" = "wayland";
    "XDG_SESSION_TYPE" = "wayland";

    "GTK_IM_MODULE" = "fcitx";
    "QT_IM_MODULE" = "fcitx";
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  # # set dpi for 4k monitor
  # xresources.properties = {
  #   # dpi for Xorg's font
  #   "Xft.dpi" = 150;
  #   # or set a generic dpi
  #   "*.dpi" = 150;
  # };

  gtk = {
    enable = true;

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    font = {
      name = "Noto Sans";
      package = pkgs.noto-fonts;
      size = 11;
    };

  };
}
