{
  pkgs,
  nur-pkgs-mslxl,
  ayugram-desktop,
  ...
}: {
  xdg.mimeApps.defaultApplications = {
    # "x-scheme-handler/tg" = ["org.telegram.desktop.desktop"];
    "x-scheme-handler/tg" = ["com.ayugram.desktop.desktop"];
    "x-scheme-handler/discord" = ["discord.desktop"];
    "x-scheme-handler/follow" = ["follow.desktop"];
  };
  home.packages = [
    # pkgs.telegram-desktop
    # pkgs.element-desktop
    pkgs.fluffychat

    pkgs.discord
    # pkgs.follow
    nur-pkgs-mslxl.liteloader-qqnt
    ayugram-desktop.packages.${pkgs.system}.ayugram-desktop
  ];
}
