{
  myutils,
  pkgs,
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

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = false;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = false;
    };
  };
}
